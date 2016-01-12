defmodule Zendesk.CommonApi do

  defmacro __using__(_) do
    quote do

      defp perform_request(parse_method, args) do
        import Zendesk.CommonApi

        internal_perform_request(parse_method,
                                 account: Dict.get(args, :account),
                                 verb:  Dict.get(args, :verb),
                                 endpoint: Dict.get(args, :endpoint),
                                 body: Dict.get(args, :body),
                                 headers: Dict.get(args, :headers))
      end

      defp internal_perform_request(parse_method, account: account, verb: verb, endpoint: endpoint, body: body, headers: headers) do
        import Zendesk.CommonApi

        prepare_params(account, body, headers)
        |> http_request(verb, full_url(account, endpoint))
        |> parse_response(parse_method)
      end

      defp parse_response(%HTTPotion.Response{status_code: status_code, body: body}, parse_method)
      when status_code == 401 or status_code == 404 do
        Zendesk.Error.from_json(body)
      end

      defp parse_response(%HTTPotion.Response{status_code: status_code}, parse_method)
      when status_code == 204 do
        parse_method.(:ok)
      end

      defp parse_response(response, parse_method) do
        parse_method.(response.body)
      end

    end
  end

  def prepare_params(account, body, headers) do
    empty_params
    |> add_auth(account)
    |> add_body(body)
    |> add_headers(headers)
  end

  def http_request(params, :get, url) do
    HTTPotion.start
    HTTPotion.get(url, params)
  end

  def http_request(params, :put, url) do
    HTTPotion.start
    HTTPotion.put(url, params)
  end

  def http_request(params, :post, url) do
    HTTPotion.start
    HTTPotion.post(url, params)
  end

  def http_request(params, :delete, url) do
    HTTPotion.start
    HTTPotion.delete(url, params)
  end

  defp empty_params do
    []
  end

  defp add_auth(params, account) do
     params ++ Zendesk.Account.auth(account)
  end

  defp add_body(params, nil) do
     params
  end

  defp add_body(params, body) do
     params ++ [body: body]
  end

  defp add_body(params, nil) do
     params
  end

  defp add_headers(params, nil) do
     params
  end

  defp add_headers(params, headers) do
     params ++ [headers: headers]
  end

  def full_url(account, endpoint), do: account.url <> endpoint

end
