require 'time'
require 'byebug'
require 'json'
require 'pg'
require 'term/ansicolor'
require 'pastel'
require_relative 'database'

class Carro
  attr_accessor :placa, :nome_veiculo, :dono_do_veiculo, :hora_entrada, :hora_saida, :total_a_pagar_por_veiculo, :subtotal
end

# class CadastroVeiculo
#   attr_accessor :hora_entrada, :hora_saida, :total_a_pagar_por_veiculo
# end

class CadastramentoVeiculo
  SAIR_DO_SISTEMA = 7

  def self.menu
    system 'clear'
    puts "\nO que deseja fazer?\n\n"
    puts "Digite (1) para cadastrar entrada do veículo."
    puts "Digite (2) para cadastrar saída do veículo."
    puts "Digite (3) para buscar veículo por placa."
    puts "Digite (4) para relatório do dia."
    puts "Digite (5) para deletar um registro no postgre."
    puts "Digite (6) editar um registro de um veículo"
    puts "Digite (7) para sair."
    puts "====================================================="
    CadastramentoVeiculo.captura_item_menu
  end

  def captura_item_menu
    opcao = gets.to_i
    case opcao
    when 1
      ControleVeiculos.cadastrar_entrada
    when 2
      ControleVeiculos.cadastrar_saida
    when 3
      ControleVeiculos.buscar_veiculo
    when 4
      ControleVeiculos.volta_menu
    when 5
      ControleVeiculos.volta_menu
    when 6
      Veiculo.editar_veiculo
    when SAIR_DO_SISTEMA
      SAIR_DO_SISTEMA
    else
      puts "Você tem que digitar um número entre 1 a 5 apenas, por favor!"
      CadastroVeiculos.pausa
      CadastroVeiculos.menu
    end
  end

    def self.init
      while(true)
        choice = CadastramentoVeiculo.menu
        break if choice == SAIR_DO_SISTEMA
      end
    end

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
    #cadastroveiculo = CadastroVeiculo.new
    carro.hora_entrada = gets.chomp
    @@veiculos[carro.placa] = {carro: carro}
    # debugger
  end

  def self.cadastrar_saida
    system 'clear'
    carro = Carro.new
    print "Digite a placa do veículo: "
    carro.placa = gets.chomp
    print "Digite a hora de saída do veículo: "
    #cadastroveiculo = CadastroVeiculo.new
    carro.hora_saida = gets.chomp
    @@veiculos[carro.placa][:carro].hora_saida = carro.hora_saida
     # debugger
    ControleVeiculos.calculo(@@veiculos[carro.placa][:carro].placa, @@veiculos[carro.placa][:carro].hora_entrada, @@veiculos[carro.placa][:carro].hora_saida)
  end
  # debugger
  def self.calculo(placa, hora_entrada, hora_saida)
    #debugger
    hora_entrada = Time.strptime(hora_entrada, "%H:%M")
    hora_saida = Time.strptime(hora_saida, "%H:%M")
    minuto_total = ((hora_saida) - (hora_entrada)) / 60
    resultado = minuto_total * 0.17
    @@veiculos[placa][:total_a_pagar_por_veiculo] = resultado
    puts "+====================================+"
    puts "|  O VALOR TOTAL A PAGAR É: #{sprintf('R$ %.2f', resultado)}. |"
    puts "+====================================+"
  end

  def self.calcular_subtotal
    subtotal = 0
    @@veiculos.each do |placa, dados|
      subtotal += dados[:total_a_pagar_por_veiculo] || 0
      @@veiculos[placa][:carro].subtotal = subtotal
      #debugger
    end
  end
end

CadastramentoVeiculo.init
