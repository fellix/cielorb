# Cielorb TODOs

Algumas idéias aqui ainda são esboços e podem nunca serem implementadas

* Mudar o nome do metodo ```make``` para ```create```
* Manter o objeto response dentro de transaction e acessar os valores de reponse via delegate
* Não permitir que um transaction com response possa ser criado novamente.
* O metodo ```create``` deve retornar true ou false
* Criar um método ```create!``` que irá lançar uma expception para o caso de erro
* Criar métodos ```success?``` e ```failure?``` em Cielo::Transaction, que indicam se a requisição foi processada com sucesso.