# Cielorb

Gem para comunicação com os serviços da cielo de processamento de pagamento

## Installation

Add this line to your application's Gemfile:

    gem 'cielorb'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cielorb

## Usage

Primeiro você deve definir a especificação de conexão, que pode ser uma instancia de Cielo::Spec,
ou um objeto que responda a mesma assinatura

```ruby
spec = Cielo::Spec.new(token: "MyToken", number: "MyNumber")
```

Com a spec definida, é possível iterar entre os serviços da cielo.

### Criando transações

Uma transação é uma operação para efeturar uma cobrança em um determinado cartão

```ruby
Cielo::Transaction.new(spec) do |request|
  request.payer_data do |data|
    data.number "4242 4242 4242 4242"
  end
end
```

Para mais informações de como preencher a requisição, consulte o manual da cielo.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
