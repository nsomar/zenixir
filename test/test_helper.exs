ExUnit.start()

defmodule TestHelper do

  def __using__(_) do

    quote do
      use ExVCR.Mock

      setup_all do
        ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
        :ok
      end

    end

  end

end
