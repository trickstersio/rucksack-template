Router = Rucksack.router do
  get "/", Alive::Endpoints::Alive
  get "/me", Sessions::Endpoints::Show

  post "/operators/login", Sessions::Endpoints::Create, params: { kind: Sessions::Owners::Operator::KIND }
end
