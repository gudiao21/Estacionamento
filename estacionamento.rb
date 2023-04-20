require 'time'
require 'byebug'
require 'json'
require 'pg'
require 'term/ansicolor'
require 'pastel'
require_relative 'database'

#debugger
class Veiculo

  def self.editar_veiculo #Receberá novos valores para o veículo.
    system 'clear'
    print "Digite a placa do veículo que deseja editar: "
    placa = gets.chomp
    print "Digite o novo nome do veículo: "
    nome_veiculo = gets.chomp
    print "Digite o novo nome do dono do veículo: "
    dono_do_veiculo = gets.chomp
    print "Digite a nova hora de entrada do veículo: "
    hora_entrada_str = gets.to_s.chomp
    hora_entrada = Time.parse(hora_entrada_str).strftime("%Y-%m-%d %H:%M:%S")

    # Chama o método de edição do veículo
    Database.edit_veiculo(placa, nome_veiculo, dono_do_veiculo, hora_entrada)

    # Exibe uma mensagem de sucesso
    puts "Veículo editado com sucesso!"

    ControleVeiculos.volta_menu
  end

end

class ControleVeiculos #Sempre no padrão de codificação "Pascal Case".
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
    ControleVeiculos.captura_item_menu
  end


  def self.captura_item_menu
    opcao = gets.to_i
    case opcao
    when 1
      Database.inserir_veiculo
    when 2
      ControleVeiculos.cadastrar_saida
    when 3
      ControleVeiculos.buscar_veiculo
    when 4
      Database.relatorio_veiculos
      ControleVeiculos.volta_menu
    when 5
      Database.delete_veiculo_pela_placa
      ControleVeiculos.volta_menu
    when 6
      Veiculo.editar_veiculo
    when SAIR_DO_SISTEMA
      SAIR_DO_SISTEMA
    else
      puts "Você tem que digitar um número entre 1 a 5 apenas, por favor!"
      ControleVeiculos.pausa
      ControleVeiculos.menu
    end
  end

  def self.cadastrar_saida
    #debugger
    system 'clear'
    puts "\n|----- Voce escolheu a opção: (2)CADASTRAR SAÍDA DO VEÍCULO -----|\n\n"

    #debugger
    print "Digite a placa do veiculo: "
    placa = ""
    while placa.empty?
      placa = gets.to_s.strip
    end

    print "Digite a hora de saída do veículo (formato: HH:MM): "
    hora_saida_str = ""
    while hora_saida_str.empty?
      hora_saida_str = gets.chomp
    end
    hora_saida = Time.parse(hora_saida_str).strftime("%Y-%m-%d %H:%M:%S")

    Database.registrar_saida(placa, hora_saida)
    ControleVeiculos.volta_menu
  end

  def self.buscar_veiculo
     Database.buscar_veiculo
     ControleVeiculos.volta_menu
  end

  def self.calculo(placa, hora_entrada, hora_saida)
    #debugger
    hora_entrada = Time.strptime(hora_entrada, "%H:%M")
    hora_saida = Time.strptime(hora_saida, "%H:%M")
    minuto_total = ((hora_saida) - (hora_entrada)) / 60
    resultado = minuto_total * 0.17
    @@veiculos[placa][:total_a_pagar] = resultado
    puts "+====================================+"
    puts "|  O VALOR TOTAL A PAGAR É: #{sprintf('R$ %.2f', resultado)}. |"
    puts "+====================================+"
    #ControleVeiculos.objeto_json
    ControleVeiculos.volta_menu
  end

  def self.calcular_subtotal
    subtotal = 0
    @@veiculos.each do |placa, dados|
      subtotal += dados[:total_a_pagar] || 0
      @@veiculos[placa][:subtotal] = subtotal
      #ControleVeiculos.objeto_json
    end
  end


  def self.volta_menu
    puts "+---------------------------------------------+"
    puts "|  Digite (M) para voltar ao MENU PRINCIPAL.  |"
    puts "+---------------------------------------------+"
    decisao = gets.to_s.upcase.strip.chomp
    while decisao != "M"
      system 'clear'
      puts "+-------------------------------------+"
      puts "|Obrigatoriamente tem que digitar (M).|"
      puts "|  Digite (M) para o MENU principal.  |"
      puts "+-------------------------------------+"
      decisao = gets.to_s.upcase.strip.chomp
    end
    decisao = "M"
    ControleVeiculos.menu
  end

  def self.pausa
    sleep(4)
  end

  def self.init
    while(true)
      choice = ControleVeiculos.menu
      break if choice == SAIR_DO_SISTEMA
    end
  end

end

ControleVeiculos.init

#alteração1

