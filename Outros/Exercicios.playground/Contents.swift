//: Playground - noun: a place where people can play

import UIKit

//var str = "Hello, playground"

/*exercicio 1*/
func eImpar(num: Int) -> Bool{
    return num%2 != 0
}


/*exercicio 2*/
func fatorial(num:Int) -> Int{
    var resultado = 1
    for var i = num; i > 0; --i {
        resultado = i * resultado
    }
    return resultado
}


/*exercicio 3*/
func minEMax(vetor: [Int]) -> (min: Int, max: Int)? {
    var min = vetor[0]
    var max = vetor[0]
    for valor in vetor{
        if valor > max {
            max = valor
        }
        else {
            if valor < min
            {
                min = valor
            }
        }
    }
    return (min, max)
}


/*exercicio 4*/
func busca(vetor:[Int], num: Int) -> Int?{
    var i = 0
    for indexador in vetor{
        if indexador == num{
            return i
        }
        ++i
    }
    return nil
}



/*exercicio 5*/
func ePalindroma(palavra: String) -> Bool{
    var novaPalavra = ""
    var aux = palavra
    for i in aux{
        novaPalavra.append(last(aux)!)
        aux = dropLast(aux)
    }
    return palavra == novaPalavra
}

/*exercicio 6*/
func retornaImpares(vetor: [Int]) -> [Int]{
    var meuVetor = [Int]()
    for i in vetor{
        if i % 2 != 0 {
         meuVetor += [i]
        }
    }
    return meuVetor
}


/*exercicio 7*/
enum PPT:  String{
    case Pedra = "Pedra"
    case Papel = "Papel"
    case Tesoura = "Tesoura"
}

enum VitoriaDerrotaEmpate: String{
    case Vitoria = "Vitoria"
    case Derrota = "Derrota"
    case Empate = "Empate"
}

func jokenpo(jogadaUm: PPT, jogadaDois: PPT) -> VitoriaDerrotaEmpate{
    
    if jogadaUm == jogadaDois {
            return .Empate
    } else{
        if jogadaUm == PPT.Pedra{
            if jogadaDois == PPT.Tesoura{
                return .Vitoria
            }
        }else{
            if jogadaUm == PPT.Papel{
                if jogadaDois == PPT.Pedra{
                    return .Vitoria
                }
            }else{
                if jogadaUm == PPT.Tesoura{
                    if jogadaDois == PPT.Papel{
                    return .Vitoria
                    }
                }
            }
        }
    }
    return .Derrota
    
}


/*exercicio 8*/
func frequencia(vetor: [Int]) -> [Int: Int]{
    var meuDicionario:[Int:Int] = [:]
    for i in vetor{
        meuDicionario[i] = (meuDicionario[i] ?? 0) + 1
    }
    return meuDicionario
}

/*exercicio 9*/
/*protocol Shape{
    
    func area() -> Double{
    
    
    }
    func perimeter() -> Double{
    
    }
    
    
    
}

struct Circle: Shape{
    func area() -> Double {
        return 3.14159 //r2
    }
    
    
}
*/

let meuVetor = [5,6,7,3,1,1,9,9,4,3,1]
minEMax(meuVetor)
busca(meuVetor, 7)
ePalindroma("arara")
println(retornaImpares(meuVetor))
jokenpo(PPT.Pedra, PPT.Tesoura).rawValue
fatorial(6)
frequencia(meuVetor)
if eImpar(4){
    println("e impar")
}
else{
    println("e par")
}
