defmodule Tradehub.Tx do
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
      ...>     Originator: "swth1z2jz4uhz8zgt4lq9mq5slz3ukyp3grhl7nsr4x"
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

    sign = Tradehub.Wallet.sign(signing_message, wallet)

    signature = %{
      pub_key: %{
        type: "tendermint/PubKeySecp256k1",
        value: wallet.private_key |> Base.encode64()
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
      signature: [signature],
      memo: tx_memo
    }

    {tx, mode}
  end

  defp build_tx({tx, mode}) do
    %{
      mode: Atom.to_string(mode),
      tx: tx
    }
  end
end
