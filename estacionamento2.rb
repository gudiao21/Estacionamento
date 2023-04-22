require 'time'
require 'byebug'
require 'json'
require 'pg'
require 'term/ansicolor'
require 'pastel'
require_relative 'database'

class Carro
  attr_accessor :placa, :nome_veiculo, :dono_do_veiculo
end

class CadastroVeiculo
  attr_accessor :hora_entrada, :hora_saida, :total_a_pagar
end

class ControleVeiculos
  @@veiculos = {}
  def self.cadastrar_entrada
    system 'clear'
    carro = Carro.new
    print "Entre com a placa do veículo: "
    carro.placa = gets.chomp
    print "Entre com o nome do veículo: "
    carro.nome_veiculo = gets.chomp
    print "Entre com o nome do dono do veículo: "
    carro.dono_do_veiculo = gets.chomp
    print "Entre com o horário de entrada do veículo: "
    cadastroveiculo = CadastroVeiculo.new
    cadastroveiculo.hora_entrada = gets.chomp
    @@veiculos < Carro
  end

  def self.cadastrar_saida
    system 'clear'
    carro = Carro.new
    print "Digite a placa do veículo: "
    carro.placa = gets.chomp
    print "Digite a hora de saída do veículo: "
    cadastroveiculo = CadastroVeiculo.new
    cadastroveiculo.hora_saida = gets.chomp
    @@veiculos < carro
  end

  def self.calculo

  end
end

ControleVeiculos.cadastrar_entrada
ControleVeiculos.cadastrar_saida