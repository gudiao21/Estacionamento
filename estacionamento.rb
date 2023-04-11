require 'time'
require 'byebug'
require 'json'
require 'pg'
require 'term/ansicolor'
require 'pastel'
require_relative 'database'

# conn = PG.connect(
#   dbname: "estacionamento",
#   user: "postgres",
#   password: "Joacira",
#   host: "localhost",
#   port: "5432"
# )


#debugger
class Veiculo

  def mostrar_entrada_saida(placa, nome_veiculo, dono_do_veiculo, hora_entrada, hora_saida) #Método para cada veículo.
    system 'clear'
    #debugger
    puts "Placa do carro é #{placa}."
    puts "O nome do carro é #{nome_veiculo}."
    puts "O nome do proprietário é #{dono_do_veiculo}."
    puts "A hora de entrada foi #{hora_entrada}."
    if hora_saida == nil
      puts "A hora da saída ainda não foi registrada!"
      puts "=================================================="
    else
      puts "A hora de saída foi #{hora_saida}."
      puts "=================================================="
    end
    ControleVeiculos.volta_menu
  end
  #dados[:total_a_pagar] ? ("%.2f" % dados[:total_a_pagar]) : ""

  def self.editar_veiculo #Receberá novos valores para o veículo.
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
  SAIR_DO_SISTEMA = 6

  @@veiculos = {}

  def self.objeto_json
    puts "-------|Confirmação de registração em JSON|-------"
    json_veiculos = JSON.generate(@@veiculos)
    File.write('veiculos.json', json_veiculos)
    puts "Veículo(s) registrado(s):\n#{json_veiculos}"
    puts "--------------------------------------------------"
  end

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
    puts "Digite (4) para mostrar movimentação do dia."
    puts "Digite (5) para gerenciar o BD do PostgreSQL."
    puts "Digite (6) para sair."
    puts "====================================================="
    ControleVeiculos.captura_item_menu
  end

  def self.menu_postgre
    system 'clear'
    puts "\nO que deseja fazer?\n\n"
    puts "Digite (1) para deletar um registro no postgre."
    puts "Digite (2) para relatório corrente de veículos."
    puts "Digite (3) para editar um registro de um veículo."
    ControleVeiculos.captura_item_menu_postgre
    ControleVeiculos.volta_menu
  end

  def self.captura_item_menu_postgre
    opcao = gets.to_i
    case opcao
    when 1
      system 'clear'
      print "Digite a placa do veículo a ser deletado: "
      placa = gets.chomp
      #chamada do método para deletar o veículo
      Database.delete_veiculo(placa)
    when 2
      system 'clear'
      Database.relatorio_veiculos
      ControleVeiculos.volta_menu
    when 3
      system 'clear'
      Veiculo.editar_veiculo
    end

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
      ControleVeiculos.relatorio
    when 5
      ControleVeiculos.menu_postgre
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

    debugger
    print "Digite a placa do veiculo: "
    placa = gets.to_s.strip
    #debugger
    print "Digite a hora de saída do veículo (formato: HH:MM): "
    hora_saida_str = gets.chomp
    hora_saida = Time.parse(hora_saida_str).strftime("%Y-%m-%d %H:%M:%S")
    #debugger
    if @@veiculos.key?(placa) && @@veiculos[placa][:hora_saida].nil?
      #debugger
      @novo_veiculo = @@veiculos[placa]
      hora_saida = nil

      print "Digite a hora de saída do veículo (formato: HH:MM): "
      hora_saida_str = gets.chomp
      hora_saida = Time.parse(hora_saida_str).strftime("%Y-%m-%d %H:%M:%S")

      begin
        @novo_veiculo[:hora_saida] = DateTime.parse(hora_saida).to_time

            rescue ArgumentError
        print "Hora de saída inválida, tente novamente: "
        retry
      end

     Database.registrar_saida(placa, hora_saida)

      # conn = PG.connect(dbname: 'estacionamento', user: 'postgres', password: 'Joacira', host: 'localhost', port: 5432)
      # conn.prepare('insert_statement', 'INSERT INTO estacionamento (placa, nome_veiculo, dono_do_veiculo, hora_entrada) VALUES ($1, $2, $3, $4)')
      # conn.prepare('select_statement', 'SELECT * FROM estacionamento')
      # result = conn.exec_prepared('select_statement')
      #
      # puts "\n+---|confirmação de cadastro no banco de dados do postgresql|---+"
      # result.each do |row|
      #   puts "Placa: #{row['placa']}, Nome do veículo: #{row['nome_veiculo']}, Dono do veículo: #{row['dono_do_veiculo']}, Hora de entrada: #{row['hora_entrada']}"
      # end
      # puts "+-----------------------------------------------------------------+"

      #debugger
      @@veiculos[placa][:hora_saida] = hora_saida #Corrigido 07/03/23, estava @@veiculos[:placa] ...
      puts "+==========================================+"
      puts "|       SAÍDA CADASTRADA COM SUCESSO.      |"
      puts "+==========================================+"
      ControleVeiculos.objeto_json
      #debugger
      ControleVeiculos.calculo(@@veiculos[placa][:placa], @@veiculos[placa][:hora_entrada], hora_saida)

    elsif @@veiculos.key?(placa) && @@veiculos[placa][:hora_saida]
      puts "Hora de saída já registrada para essa placa!"
      ControleVeiculos.volta_menu

    else
      puts "\n\n"
      puts "+-----------------------------------------------------------------+"
      puts "|        A placa (#{placa}) ainda não foi cadastrada.             |"
      puts "| Deseja ir para a opção: (1)CADASTRAR ENTRADA DE VEÍCULO? (S/N)  |"
      puts "|                                                                 |"
      puts "+-----------------------------------------------------------------+"
      escolha = gets.to_s.upcase.strip

      case escolha
      when "S"
        ControleVeiculos.cadastrar_entrada
      when "N"
        ControleVeiculos.menu
      else
        system 'clear'
        puts "(S) ou (N) não escolhida, por isso te redirecionaremos para a opção do MENU!"
        ControleVeiculos.pausa
        ControleVeiculos.menu
      end

    end
  end

  def self.buscar_veiculo
    system 'clear'
    puts "\n|----- Voce escolheu a opção: (3)BUSCAR VEÍCULO POR PLACA -----|\n\n"
    #debugger
    print "Digite a placa do veículo: "
    placa = gets.strip
    if @@veiculos.key?(placa) #Se "placa" já estiver sendo usada como chave em @@veiculos, o que indica que um veículo com essa placa já foi cadastrado.
      veiculo = @@veiculos[placa]
      puts "Veículo de placa #{veiculo[:placa]} encontrado!"
      Veiculo.new.mostrar_entrada_saida(veiculo[:placa], veiculo[:nome_veiculo], veiculo[:dono_do_veiculo], veiculo[:hora_entrada], veiculo[:hora_saida])
    else
      puts "Veículo de placa #{veiculo} não encontrado!"
    end
    ControleVeiculos.volta_menu
  end

  def self.relatorio
    #debugger
    system 'clear'
    # Define as larguras máximas de cada coluna
    placa_width = 5
    nome_veiculo_width = 20
    dono_do_veiculo_width = 20
    hora_entrada_width = 32
    hora_saida_width = 32
    total_a_pagar_width = 14
    subtotais_width = 50

    # Cria a string de formatação
    format_string = "%-#{placa_width}s  %-#{nome_veiculo_width}s  %-#{dono_do_veiculo_width}s  %-#{hora_entrada_width}s  %-#{hora_saida_width}s  %-#{total_a_pagar_width}s  %-#{subtotais_width}s\n"

    # Imprime o cabeçalho
    puts "====================================================================================================================================================="
    puts format_string % ["Placa", "Nome do Veículo", "Dono do Veículo", "Hora de Entrada", "Hora de Saída", "Total a Pagar", "Subtotais"]
    puts "====================================================================================================================================================="
    #debugger
    ControleVeiculos.calcular_subtotal
    # Percorre todos os veículos e os imprime formatados:
    @@veiculos.each do |placa, dados|
      # Substitui valores nulos ou vazios por uma string vazia:
      placa = placa.nil? ? "" : placa
      nome_veiculo = dados[:nome_veiculo].nil? ? "" : dados[:nome_veiculo]
      dono_do_veiculo = dados[:dono_do_veiculo].nil? ? "" : dados[:dono_do_veiculo]
      hora_entrada = dados[:hora_entrada].nil? ? "" : dados[:hora_entrada]
      hora_saida = dados[:hora_saida].nil? ? "" : dados[:hora_saida]
      total_a_pagar = dados[:total_a_pagar].nil? ? "" : "%.2f" % dados[:total_a_pagar]
      subtotal = dados[:subtotal].nil? ? "" : "%.2f" % dados[:subtotal]
      printf(format_string, placa, dados[:nome_veiculo], dados[:dono_do_veiculo], dados[:hora_entrada], dados[:hora_saida], dados[:total_a_pagar] ? ("%.2f" % dados[:total_a_pagar]) : 0, dados[:subtotal] ? ("%.2f" % dados[:subtotal]) : 0)
    end
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
