require 'pg'

class Database
  def self.delete_veiculo(placa)
    begin
      conn = PG.connect(dbname: 'estacionamento', user: 'postgres', password: 'Joacira', host: 'localhost', port: '5432')
      #conn = PG.connect(dbname: 'estacionamento', user: 'postgres', password: 'Joacira')
      conn.exec_params("DELETE FROM estacionamento.controle_veiculos WHERE placa = '#{placa}'")
    rescue PG::Error => e
      puts e.message
    ensure
      conn.close unless conn.nil?
    end
    print "Veículo de placa #{placa} foi excluído com sucesso!"
  end

  def self.relatorio_veiculos
    begin
      conn = PG.connect(dbname: 'estacionamento', user: 'postgres', password: 'Joacira', host: 'localhost', port: '5432')
      result = conn.exec("SELECT * FROM estacionamento.controle_veiculos;")
      puts "+----------------------------------------------------------| Relatório dos veículos registrados até o momento |----------------------------------------------------------------------------+\n|"
      result.each do |row|
        puts "|                     Placa: #{row['placa']}, Nome do veículo: #{row['nome_veiculo']}, Dono do veículo: #{row['dono_do_veiculo']}, Hora de entrada: #{row['hora_entrada']}, Hora de saída: #{row['hora_saida']}"
      end
      puts "+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+"
    rescue PG::Error => e
      puts e.message
    ensure
      conn.close unless conn.nil?
    end
  end

  def self.inserir_veiculo(placa, nome_veiculo, dono_do_veiculo, hora_entrada)
      begin
        conn = PG.connect(dbname: 'estacionamento', user: 'postgres', password: 'Joacira', host: 'localhost', port: '5432')
        conn.exec_params("INSERT INTO estacionamento.controle_veiculos (placa, nome_veiculo, dono_do_veiculo, hora_entrada) VALUES ($1, $2, $3, $4)", [placa, nome_veiculo, dono_do_veiculo, hora_entrada])
      rescue PG::Error => e
        puts e.message
      ensure
        conn.close unless conn.nil?
      end
  end

  def self.edit_veiculo(placa, nome_veiculo, dono_do_veiculo, hora_entrada)
    begin
      conn = PG.connect(dbname: 'estacionamento', user: 'postgres', password: 'Joacira', host: 'localhost', port: '5432')
      conn.exec_params("UPDATE estacionamento.controle_veiculos SET nome_veiculo=$1, dono_do_veiculo=$2, hora_entrada=$3 WHERE placa=$4", [nome_veiculo, dono_do_veiculo, hora_entrada, placa])
    rescue PG::Error => e
      puts e.message
    ensure
      conn.close unless conn.nil?
    end
  end

  def self.registrar_saida(placa, hora_saida)
    # print "Digite a placa do veículo que deseja editar: "
    # placa = gets.chomp
    # print "Digite a hora da saída do veículo: "
    # hora_saída_str = gets.to_s.chomp
    # hora_saida = Time.parse(hora_entrada_str).strftime("%Y-%m-%d %H:%M:%S")

    connection = PG.connect(host: 'localhost', dbname: 'estacionamento', user: 'postgres', password: 'Joacira')
    connection.prepare('insert_saida', 'INSERT INTO estacionamento.controle_veiculos (placa, hora_saida) VALUES ($1, $2)')
    result = connection.exec_prepared('insert_saida', [placa, hora_saida])
    connection.close
  end

end