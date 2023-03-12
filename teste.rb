#Exemplar de código mostra como chamar um método dentro de uma classe, quando se está em um outro método dentro de outra diferente classe:

# class MinhaClasse
#     def meu_metodo
#       puts "Olá do meu método!"
#     end
# end

# class OutraClasse
#     def chamar_metodo_da_outra_classe
#       instancia_da_minha_classe = MinhaClasse.new
#       instancia_da_minha_classe.meu_metodo
#     end
# end

# outra_classe = OutraClasse.new
# outra_classe.chamar_metodo_da_outra_classe

def self.cadastrar_entrada
    #debugger
    system 'clear'
    puts "\n|----- Voce escolheu a opção: (1)CADASTRAR ENTRADA DO VEÍCULO -----|\n\n"
    @novo_veiculo = {}
    print "Digite a placa do veiculo: "
    @novo_veiculo[:placa] = gets.to_s.strip.chomp
    print "Digite o nome do veículo: "
    @novo_veiculo[:nome_veiculo] = gets.to_s.strip.chomp
    print "Digite o nome do proprietário do veículo: "
    @novo_veiculo[:dono_do_veiculo] = gets.to_s.chomp
    print "Digite a hora de entrada do veículo: "
    @novo_veiculo[:hora_entrada] = Time.parse(gets.chomp)
    @@veiculos[@novo_veiculo[:placa]]= @novo_veiculo
    puts "+==========================================+"
    puts "|      VEÍCULO CADASTRADO COM SUCESSO.     |"
    puts "+==========================================+"
    ControleVeiculos.volta_menu
end