defmodule Tradehub.Tx do
  @moduledoc """
  This module aims to construct, generate, and broadcast messages accross the Tradehub blockchain.
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

  @type signing_message :: %{
          accountNumber: String.t(),
          chainId: String.t(),
          fee: fee(),
          memo: String.t(),
          msgs: list(message()),
          sequence: String.t()
        }

  @type signature :: %{
          pub_key:
            pub_key :: %{
              type: String.t(),
              value: String.t()
            },
          signature: String.t()
        }

  @type tx :: %{
          fee: fee(),
          msg: list(message()),
          signature: list(signature()),
          memo: String.t()
        }

  @type complete_tx :: %{
          fee: fee(),
          mode: String.t(),
          tx: tx()
        }

  def test do
    {:ok, wallet} = Tradehub.Wallet.from_mnemonic("second enter wire knee dial save code during ankle grape estate run")

    new_order_payload =
      Tradehub.Tx.CreateOrder.build(%{
        market: "swth_eth1",
        side: "buy",
        quantity: "100",
        price: "1.01000000000",
        originator: wallet.address
      })

    messages = [new_order_payload]

    tx =
      {messages, wallet}
      |> generate_signing_messages
      |> sign
      |> construct_tx("")
      |> build_tx
      |> Jason.encode!()

    Tradehub.send(tx)
  end

  @doc """
  Build a package for broadcasting arcoss the chain, the package includes the given messages, and signed
  by using the private key of the given tradehub Wallet

  Packaging messages consists steps as below:

  1. Given raw messages that constist of the message `type` and an `object` containing the message params.
  2. Construct signing messages
  3. Construct the digest by marshalling the `signing message` into a JSON format, and applying the hash algorithm SHA256
  4. Sign the digest with the private key
  5. Combine the messages with its signatur, set fee, and memo if any.
  6. Complete Tx, mode: `block` to wait for the txn to be accepted into the block.

  ## Examples

      iex> wallet = Tradehub.Wallet.create_wallet()
      iex> message = %{
      ...>  type: "order/CreateOrder",
      ...>  value: %{
      ...>     Market: "swth_eth",
      ...>     Side: "sell",
      ...>     Quantity: "200",
      ...>     Price: "1.01",
      ...>     Originator: "tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t"
      ...>   }
      ...> }
      iex> Tradehub.Tx.build(message, wallet)

  """

  def generate_signing_messages({messages, wallet}) do
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

    {messages, signing_message, wallet}
  end

  ## Private functions

  def sign({messages, signing_message, wallet}) do
    {:ok, sign} = Tradehub.Wallet.sign(signing_message, wallet)

    signature = %{
      pub_key: %{
        type: "tendermint/PubKeySecp256k1",
        value: wallet.public_key |> Base.encode64()
      },
      signature: sign
    }

    {messages, signature}
  end

  def construct_tx({messages, signature}, _memo \\ nil) do
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
      signatures: [signature]
      # memo: memo
    }
  end

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
