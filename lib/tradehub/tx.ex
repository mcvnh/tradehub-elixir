defmodule Tradehub.Tx do
  @moduledoc """
  This module aims to construct, generate, and broadcast messages accross the Tradehub blockchain.

  To pack messages for broadcasting across the the chain, it consists steps as below:

  1. Given raw messages that constist of the message `type` and an `object` containing the message params.
  2. Construct signing messages
  3. Construct the digest by marshalling the `signing message` into a JSON format, and applying the hash algorithm SHA256
  4. Sign the digest with the private key
  5. Combine the messages with its signatur, set fee, and memo if any.
  6. Complete Tx, mode: `block` to wait for the txn to be accepted into the block.

  ## Examples

      iex> import Tradehub.Tx
      iex> wallet = Tradehub.Wallet.from_mnemonic!("second enter wire knee dial save code during ankle grape estate run")
      iex> message =
      ...> Tradehub.Tx.CreateOrder.build(%{
      ...>   market: "swth_eth1",
      ...>   side: "buy",
      ...>   quantity: "100",
      ...>   price: "1.01000000000",
      ...>   originator: wallet.address
      ...> })
      iex> msg =
      ...>   {wallet, [message]}
      ...>   |> generate_signing_message()
      ...>   |> sign()
      ...>   |> construct_tx()
      ...>   |> build_tx()
      ...>   |> Jason.encode!()
      iex> Tradehub.send(msg)
  """

  @typedoc "The fee you might have to spend to broadcast the message"
  @type fee :: %{
          amount: list(Tradehub.amount()),
          gas: String.t()
        }

  @typedoc """
  The payload that actually broadcast across over the blockchain.
  It is then used to form the signing message.
  """
  @type message :: %{
          type: String.t(),
          value: map()
        }

  @typedoc "Signing message"
  @type signing_message :: %{
          accountNumber: String.t(),
          chainId: String.t(),
          fee: fee(),
          memo: String.t(),
          msgs: list(message()),
          sequence: String.t()
        }

  @typedoc "Signature for a signing message"
  @type signature :: %{
          pub_key:
            pub_key :: %{
              type: String.t(),
              value: String.t()
            },
          signature: String.t()
        }

  @typedoc "Transaction"
  @type tx :: %{
          fee: fee(),
          msg: list(message()),
          signature: list(signature()),
          memo: String.t()
        }

  @typedoc "Wrapped transaction with the network fee, and mode"
  @type complete_tx :: %{
          fee: fee(),
          mode: String.t(),
          tx: tx()
        }

  @type t :: %__MODULE__{
          wallet: Tradehub.Wallet.t(),
          payload: [message()],
          memo: String.t(),
          mode: atom(),
          signature: map(),
          signing_message: map(),
          tx: tx()
        }
  defstruct wallet: nil,
            payload: [],
            memo: nil,
            mode: :block,
            signature: nil,
            signing_message: nil,
            tx: nil

  def test do
    wallet = Tradehub.Wallet.from_mnemonic!("second enter wire knee dial save code during ankle grape estate run")

    message =
      Tradehub.Tx.CreateOrder.build(%{
        market: "swth_eth1",
        side: "buy",
        quantity: "100",
        price: "1.01000000000",
        originator: wallet.address
      })

    msg =
      {wallet, [message]}
      |> generate_signing_message()
      |> sign()
      |> construct_tx()
      |> build_tx()
      |> Jason.encode!()

    Tradehub.send(msg)
  end

  @doc """
  This is the first step of buiding a transaction. It purposes is to fetch the information of the given wallet
  and generate a signing message that contains information about account number, chain id, and the fee you might
  have to spend for handling messages once it broadcasted to the blockchain.
  """

  @spec generate_signing_message({Tradehub.Wallet.t(), [message()]}) :: tuple()

  def generate_signing_message({wallet, messages}) do
    {:ok, account} = Tradehub.Account.account(wallet.address)

    accountNumber = account.result.value.account_number
    sequence = account.result.value.sequence

    chainId =
      case wallet.network do
        :mainnet -> "switcheochain"
        :testnet -> "switcheo-tradehub-1"
      end

    signing_message = %{
      accountNumber: accountNumber,
      chainId: chainId,
      fee: %{
        amount: [
          %{
            denom: "swth",
            amount: "100000000"
          }
        ],
        gas: "100000000000"
      },
      msgs: messages,
      sequence: sequence
    }

    {wallet, messages, signing_message}
  end

  @spec sign({Tradehub.Wallet.t(), any, map}) ::
          {any, %{optional(:pub_key) => %{type: <<_::208>>, value: binary}, optional(:signature) => binary}}
  @doc """
  Sign the signing message with the wallet private key.
  """

  def sign({wallet, messages, signing_message}) do
    case Tradehub.Wallet.sign(signing_message, wallet) do
      {:ok, sign} ->
        signature = %{
          pub_key: %{
            type: "tendermint/PubKeySecp256k1",
            value: wallet.public_key |> Base.encode64()
          },
          signature: sign
        }

        {messages, signature}

      _ ->
        {messages, %{}}
    end
  end

  @doc """
  Construct the transaction.
  """

  @spec construct_tx({[message()], signature()}, String.t()) :: any()

  def construct_tx({messages, signature}, memo \\ "") do
    %{
      fee: %{
        amount: [
          %{
            denom: "swth",
            amount: "100000000"
          }
        ],
        gas: "100000000000"
      },
      msg: messages,
      signatures: [signature],
      memo: memo
    }
  end

  @doc """
  Wrap the transaction with the network fee
  """

  @spec build_tx(any, atom) :: %{fee: %{amount: [map, ...], gas: <<_::96>>}, mode: binary, tx: any}

  def build_tx(tx, mode \\ :block) do
    %{
      mode: Atom.to_string(mode),
      tx: tx,
      fee: %{
        amount: [
          %{
            denom: "swth",
            amount: "100000000"
          }
        ],
        gas: "100000000000"
      }
    }
  end
end
