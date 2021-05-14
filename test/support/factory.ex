defmodule Dashy.Factory do
  use ExMachina.Ecto, repo: Dashy.Repo

  use Dashy.WorkflowFactory
  use Dashy.WorkflowRunFactory
end
