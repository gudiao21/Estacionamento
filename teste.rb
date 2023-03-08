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

if @@veiculos.key?(placa)
    #debugger
    print "Digite a hora de saída do veículo: "
    hora_saida_string = gets.chomp
    puts "Hora de saída digitado: (#{hora_saida_string})."
    hora_saida = Time.strptime(hora_saida_string, "%H:%M")
    #debugger
    @@veiculos[placa][:hora_saida] = @novo_veiculo #Corrigido 07/03/23, estava @@veiculos[:placa] ...
    @@veiculos[@novo_veiculo[:placa]][:hora_saida] = hora_saida
    puts "+==========================================+"
    puts "|       SAÍDA CADASTRADA COM SUCESSO.      |"
    puts "+==========================================+"
    ControleVeiculos.pausa
    #debugger
    ControleVeiculos.calculo(@@veiculos[placa][:hora_entrada], hora_saida)
else