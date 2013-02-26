# Cielorb

Gem para comunicação com os serviços da cielo de processamento de pagamento.

Esse projeto se encontra em desenvolvimento nesse momento.

## Instalação

Adicione essa linha ao Gemfile da sua aplicação:

    gem 'cielorb', :git => "git://github.com/fellix/cielorb.git"

Então execute:

    $ bundle

## Usage

Primeiro você deve definir a especificação de conexão, que pode ser uma instancia de Cielo::Spec,
ou um objeto que responda a mesma assinatura

```ruby
spec = Cielo::Spec.new(token: "MyToken", number: "MyNumber", endpoint: "URL do serviço a ser enviado os dados")
```

Com a spec definida, é possível acessar os serviços da cielo.

### Criando transações

Uma transação é uma operação para efeturar uma cobrança em um determinado cartão

```ruby
transaction = Cielo::Transaction.new(spec) do |request|
  request.payer_data do |data|
    data.number "4242 4242 4242 4242"
  end
end

transaction.create
# => true

transaction.success?
# => true

transaction.failure?
# => false

transaction.create # criando segunda vez consecutiva
# => Cielo::Transaction::AlreadyPerformed: transaction already created
```

Para mais informações de como preencher a requisição, [veja esse arquivo de teste](https://github.com/fellix/cielorb/blob/master/test/transaction_request_test.rb#L8-L37).

### Trabalhando com a resposta

A resposta de uma transação só estará disponível após ser feita chamada a ``` create ``` e pode conter dois elementos.

#### Erro na requisição

Caso o serviço tenha retornado algum erro, seu objeto de resposta vai conter um outro objeto chamado erro:

```ruby
transaction.error.to_s
# => ERROR 002 - Credenciais inválidas
transaction.error.code
# => 002
transaction.error.message
# => Credenciais inválidas
```

#### Requisição efetuada com sucesso

Quanto a resposta da cielo for uma requisição válida, vamos ter elementos de retorno do xml

``` ruby
transaction.error.nil?
# => true
transaction.tid
# => 10069930690C6BA3A001
```

outros conteúdos do xml estão disponíveis como métodos: ```pan```, ```status```, ```authentication_url```, ```order_data```, ```payment_method```

## Contribuindo

1. Fork it
2. Crie um branch com o nome da sua feature (`git checkout -b my-new-feature`)
3. Faça um commit (`git commit -am 'Add some feature'`)
4. Envie os dados para seu fork (`git push origin my-new-feature`)
5. Crie um Pull Request
