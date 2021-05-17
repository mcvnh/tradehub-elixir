defmodule Tradehub.Tx do
  @moduledoc """
  Use this module to broadcast your messages into the Tradehub blockchain.

  The steps of broadcasting messages describes as below:

  1. Compose your messages
  2. Construct signing messages
  3. Sign the signing messages with your private key
  4. Construct tx
  5. Construct completeTx

  ## Examples

      iex> import Tradehub.Tx
      iex> wallet = Tradehub.Wallet.from_mnemonic! Application.fetch_env!(:tradehub, :wallet)
      iex> message =
      ...>   %{
      ...>     username: "trade",
      ...>     twitter: "mvanh91",
      ...>     originator: wallet.address
      ...>   }
      ...>   |> Tradehub.Tx.MsgUpdateProfile.build()
      iex> {wallet, [message]}
      ...>   |> generate_signing_message()
      ...>   |> sign()
      ...>   |> construct_tx()
      ...>   |> build_tx()
      ...>   |> Jason.encode!()
      ...>   |> Tradehub.send

    Or

      iex> import Tradehub.Tx
      iex> wallet = Tradehub.Wallet.from_mnemonic! Application.fetch_env!(:tradehub, :wallet)
      iex> message =
      ...>   %{
      ...>     username: "trade",
      ...>     twitter: "mvanh91",
      ...>     originator: wallet.address
      ...>   }
      ...>   |> Tradehub.Tx.MsgUpdateProfile.build()
      iex> broadcast([message], wallet)

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
          account_number: String.t(),
          chain_id: String.t(),
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

  @spec broadcast(list(message()), Tradehub.Wallet.t(), String.t()) :: any()

  def broadcast(messages, wallet, memo \\ "") do
    {wallet, messages}
    |> generate_signing_message()
    |> sign()
    |> construct_tx(memo)
    |> build_tx()
    |> Jason.encode!()
    |> Tradehub.send()
  end

  @doc """
  This is the first step of buiding a transaction. It purposes is to fetch the information of the given wallet
  and generate a signing message that contains information about account number, chain id, and the fee you might
  have to spend for handling messages once it broadcasted to the blockchain.
  """

  @spec generate_signing_message({Tradehub.Wallet.t(), [message()]}) :: tuple()

  def generate_signing_message({wallet, messages}) do
    {:ok, account} = Tradehub.Account.account(wallet.address)

    account_number = account.result.value.account_number
    sequence = account.result.value.sequence

    chain_id =
      case wallet.network do
        :testnet -> "switcheochain"
        :mainnet -> "switcheo-tradehub-1"
      end

    signing_message = %{
      account_number: account_number,
      chain_id: chain_id,
      fee: %{
        amount: [
          %{
            amount: Integer.to_string(1 * length(messages)) <> "00000000",
            denom: "swth"
          }
        ],
        gas: "100000000000"
      },
      memo: "",
      msgs: messages,
      sequence: sequence
    }

    {wallet, messages, signing_message}
  end

  @doc """
  Sign the signing message with the wallet private key.
  """

  @spec sign({Tradehub.Wallet.t(), list(message()), signing_message()}) :: {list(message()), signature()}

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

  @spec build_tx(any, atom) :: %{mode: binary, tx: any}

  def build_tx(tx, mode \\ :block) do
    %{
      mode: Atom.to_string(mode),
      tx: tx
    }
  end
end
