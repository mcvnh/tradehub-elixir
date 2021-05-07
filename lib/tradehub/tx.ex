# clumb twenty either puppy thank liquid vital rigid tide tragic flash elevator
# VAib7NRsfnc1aJPvA2JpRKqr4s7kUfwYzrjuQZa1z6ok2MaN9tjgNvjN3Xz3FGmE7RRsapL3sx7CH5bP5xwc3KKVuxj4R5B1L85oRym2DdmjPSDewD2ZyDjUsWum2SVGmwsWnh3s5xFTGZ2dxMq51CLnvG46BZk5GHjXeNBGdrFDPAeFKC9jQVcd7kh43EBWNVs6trTw7r3KZAkXHSEzase2NN7K2W4pbEqacn4Vyu1BGnRAoo6H6mwBCrXgcSNH4c4qWFrTcqERPT6MULB1anMbzQkaJ7kkC8JDmYq5xRMXmZWRTL67EXGR3x39xqvWvgpgFS8MwqKuiudzmMbCFwEANMu9ZHomaBc6UsXWNi1SeRJ
# 123456!aA
# 2xbEeBv7aAGZoRJgSroghd4rFUJqnz3d1qspPLTEcFwT3pquaUB6uy2fSy7MPuZgPFrqV1KcCzqbdy9nCddCN9yMpkmwHYLfiNWMLaYSWB1W8MdmCGDNLYif31TJDhQxQ6d8ArkBhf6NCwW6v5Yezh99b7MuJPZNjaBVJ9vWA7F2hbHBvH93G3yZxAQpzQ1xieimYvwUKfv7e2BQXJjqYE4zPkUNKrLp8jVB9k299bpoFR6F134ZCXyGwsm4wJGAN5wpBVJadZDetfM27vQbBzumsVyHZTDVbqqB5U8qVW1ewM1JoUBCwhyr8uDQ4hkdQtVgo6djT7W3hA1o5BvMGqVa2nd1Ngh4ik
# second enter wire knee dial save code during ankle grape estate run
defmodule Tradehub.Tx do
  def test do
    {:ok, wallet} =
      Tradehub.Wallet.from_mnemonic("clumb twenty either puppy thank liquid vital rigid tide tragic flash elevator")

    message = %{
      type: "profile/UpdateProfile",
      value: %{
        User: "my_name_is_cool",
        Twitter: "swth_eth1",
        Originator: wallet.address
      }
    }

    tx = build(message, wallet) |> Jason.encode!()

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

  # @spec build([Tradehub.message()] | Tradehub.message(), Tradehub.Wallet.t(), String.t(), atom()) ::
  #         Tradehub.complete_tx()

  def build(messages, wallet, tx_memo \\ "", mode \\ :block)

  def build(messages, wallet, tx_memo, mode) when not is_list(messages), do: build([messages], wallet, tx_memo, mode)

  def build(messages, wallet, tx_memo, mode) when is_list(messages) do
    {messages, wallet, tx_memo, mode}
    |> sign_messages
    |> construct_tx
    |> build_tx
  end

  ## Private functions

  defp sign_messages({messages, wallet, tx_memo, mode}) do
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

    {:ok, sign} = Tradehub.Wallet.sign(signing_message, wallet)

    signature = %{
      pub_key: %{
        type: "tendermint/PubKeySecp256k1",
        value: wallet.public_key |> Base.encode64()
      },
      signature: sign
    }

    {messages, mode, tx_memo, signature}
  end

  defp construct_tx({messages, mode, tx_memo, signature}) do
    tx = %{
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
      memo: tx_memo
    }

    {tx, mode}
  end

  defp build_tx({tx, mode}) do
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
