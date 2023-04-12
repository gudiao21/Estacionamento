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
  SAIR_DO_SISTEMA = 8

  def initialize
    @veiculos = {}
    @novo_veiculo = {}
  end

  def self.veiculos
    @@veiculos
  end

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
      ControleVeiculos.cadastrar_entrada
    when 2
      ControleVeiculos.cadastrar_saida
    when 3
      ControleVeiculos.buscar_veiculo
    when 4
      Database.relatorio_veiculos
    when 5
      Database.delete_veiculo
    when 6
      print "Digite a placa do veículo a ser deletado: "
      placa = gets.chomp
      #chamada do método para deletar o veículo
      Database.delete_veiculo(placa)
    when 7
      Veiculo.editar_veiculo
    when SAIR_DO_SISTEMA
      SAIR_DO_SISTEMA
    else
      puts "Você tem que digitar um número entre 1 a 5 apenas, por favor!"
      ControleVeiculos.pausa
      ControleVeiculos.menu
    end
  end

  def self.cadastrar_entrada
    #debugger
    system 'clear'
    puts "\n|----- Voce escolheu a opção: (1)CADASTRAR ENTRADA DO VEÍCULO -----|\n\n"
    @novo_veiculo = {}

    placa = ""
    print "Digite a placa do veículo: "
    while (placa = gets.to_s.strip).empty?
      system 'clear'
      print "A placa do veículo não pode ser vazia, digite novamente: "
    end

    if @@veiculos.has_key?(placa)
      puts "Essa placa (#{placa}) já foi cadastrada!"
      ControleVeiculos.volta_menu
    else
      @@veiculos[:total_a_pagar] ? ("%.2f" % @@veiculos[:total_a_pagar]) : ""
      @novo_veiculo[:placa] = placa
    end

    print "Digite o nome do veículo: "
    while (nome_veiculo = gets.to_s.strip).empty?
      print "Nome do veículo não pode ser vazio, digite novamente: "
    end
    @novo_veiculo[:nome_veiculo] = nome_veiculo

    print "Digite o nome do proprietário do veículo: "
    while (dono_do_veiculo = gets.to_s.strip).empty?
      print "Nome do dono do veículo não pode ser vazio, digite novamente: "
    end
    @novo_veiculo[:dono_do_veiculo] = dono_do_veiculo
    #debugger
    print "Digite a hora de entrada do veículo (formato: HH:MM): "
    hora_entrada = Time.parse(gets.to_s.strip.chomp)
    until hora_entrada.strftime('%H:%M') =~ /^\d{2}:\d{2}$/
      print "Hora de entrada inválida, digite novamente (formato: HH:MM): "
      hora_entrada = Time.parse(gets.to_s.strip.chomp)
    end
    #hora_entrada_str = hora_entrada.strftime("%Y-%m-%d %H:%M:%S")
    #debugger
    @novo_veiculo[:hora_entrada] = (hora_entrada)
    #@@veiculos[placa][:hora_entrada] = hora_entrada
    begin
      #@novo_veiculo[:hora_entrada] = DateTime.parse(hora_entrada).to_time

    rescue ArgumentError
      print "Hora de entrada inválida, tente novamente: "
      retry
    end

    #Chamada para o método de insert no arquivo "database.rb".
    Database.inserir_veiculo(placa, nome_veiculo, dono_do_veiculo, hora_entrada)

    @@veiculos[@novo_veiculo[:placa]]= @novo_veiculo
    puts "+==========================================+"
    puts "|      VEÍCULO CADASTRADO COM SUCESSO.     |"
    puts "+==========================================+"
    #ControleVeiculos.objeto_json
    ControleVeiculos.volta_menu
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


  end

  def self.buscar_veiculo
     system 'clear'
     puts "\n|----- Voce escolheu a opção: (3)BUSCAR VEÍCULO POR PLACA -----|\n\n"
  #   #debugger
     print "Digite a placa do veículo: "
     placa = gets.strip
     Database.buscar_veiculo(placa)

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
