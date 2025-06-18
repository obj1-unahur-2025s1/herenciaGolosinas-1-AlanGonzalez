// De cada golosina interesan: el precio, el sabor, su peso en gramos y si contiene gluten.
// Además, cada vez que una golosina recibe un mordisco se reduce la cantidad de gramos que posee.

class Golosina {
	var property peso
	var property esBaniada = false
	method libreDeGluten()
	method pesos()
	method mordisco()
	
}

class Bombon inherits Golosina (peso = 15){
	override method peso() = 15
	override method pesos() = 5
	method gusto() = "frutilla"
	override method libreDeGluten() = true
	override method mordisco() { peso = (peso * 0.8) - 1}

}

class BombonDuro inherits Bombon {
	override method mordisco() {peso = (peso - 1).max(0)}
	method gradoDureza() = if(peso > 12) 3 else if(peso.between(8, 12)) 2 else 1
}

class Alfajor inherits Golosina (peso = 300){
	override method pesos() = 12
	method gusto() = "chocolate"
	override method libreDeGluten() = false
	override method mordisco() { peso = peso * 0.8}

}

class Caramelo inherits Golosina( peso = 1) {
	var property gusto
	override method pesos() = 1
	override method libreDeGluten() = true
	override method mordisco() { peso = (peso - 1).max(0)}
}

class CarameloCorazonChocolate inherits Caramelo {
	override method mordisco() {
		super()
		gusto = "chocolate"
	}
	override method pesos() = super() + 1
}

class Chupetin inherits Golosina (peso = 7) {
	override method pesos() = 2
	method gusto() = "naranja"
	override method libreDeGluten() = true
	override method mordisco() {
    	if(peso > 2){
      		peso = peso * 0.9
    	}
	}
}

class Oblea inherits Golosina (peso = 250){
	override method pesos() = 5
	method gusto() = "vainilla"
	override method libreDeGluten() = false
	override method mordisco() {
		if(peso > 70){
			peso = peso / 2
    	}
    	else{
      		peso = peso * 0.75
    	}
	}
}

class ObleasCrujientes inherits Oblea {
	var property cantidadMordiscos = 0
	override method mordisco(){
		cantidadMordiscos = cantidadMordiscos + 1
		super()
		if(cantidadMordiscos >= 3){
			peso = (peso - 3).max(0)
		}
	}
	method estaDebil() = cantidadMordiscos >= 3
}

class Chocolatin inherits Golosina{
	var comido = 0
	override method pesos() = peso * 0.50
	override method peso() = (peso - comido).max(0)
	override method mordisco(){comido = comido + 2}
	method gusto() = "chocolate"
	override method libreDeGluten() = false
}

class ChocolatinVip inherits Chocolatin {
	override method peso()=((peso-comido)*(1+heladera.humedad())).max(0)
	method humedad() = heladera.humedad()
}

class ChocolatinPremium inherits ChocolatinVip {
	override method humedad() = super() / 2
}

object heladera {
	var property humedad = 0
	method humedad(nuevo){
		if(!nuevo.between(0,1)){
			throw new Exception(message = "debe estar entre 0 y 1")
		}
		humedad = nuevo
	}
}

class GolosinaBaniada inherits Golosina{
	var golosinaInicial
	var pesoBanio = 4
	method golosinaInicial(unaGolosina) { golosinaInicial = unaGolosina}
	override method pesos() = golosinaInicial.pesos() + 2
	override method peso() = golosinaInicial.peso() + pesoBanio
	method pesoBanio() = pesoBanio 
	method gusto() = golosinaInicial.gusto()
	override method libreDeGluten() = golosinaInicial.libreDeGluten()
	override method mordisco() {
    golosinaInicial.mordisco()
    pesoBanio = (pesoBanio - 2).max(0)
	}
	override method esBaniada() = true
}

class PastillaTutiFruti inherits Golosina(peso = 5){
	var saborActual = 0
	var property libreDeGluten
	override method libreDeGluten() = libreDeGluten
	const gusto = ["frutilla", "chocolate", "naranja"]
	override method pesos() = if(libreDeGluten) 7 else 10
	override method mordisco() { saborActual = saborActual + 1}
	method gusto() { return gusto.get(saborActual % 3) }
}

object mariano {
	const compradas = []
	const desechadas = []
	const property bolsaGolosinas = []
	method comprar(unaGolosina) { 
    bolsaGolosinas.add(unaGolosina)
    compradas.add(unaGolosina)
    }
	method desechar(unaGolosina) { 
    bolsaGolosinas.remove(unaGolosina)
    desechadas.add(unaGolosina)
    }
	method cantidadGolosinas() = bolsaGolosinas.size()
	method tieneGolosina(unaGolosina) = bolsaGolosinas.contains(unaGolosina)
	method probarGolosina() = bolsaGolosinas.forEach({g=>g.mordisco()})
	method hayGolosinasSinTACC() = bolsaGolosinas.any({g=>g.libreDeGluten()})
	method preciosCuidados() = bolsaGolosinas.any({g=>g.pesos() <= 10})
	method golosinaDeSabor(unSabor) = bolsaGolosinas.find({g=>g.gusto() == unSabor})
	method golosinasDeabor(unSabor) = bolsaGolosinas.filter({g=>g.gusto() == unSabor})
	method sabores() = bolsaGolosinas.map({g=>g.gusto()}).asSet()
	method golosinaMasCara() = bolsaGolosinas.max({g=>g.pesos()})
	method pesoGolosinas() = bolsaGolosinas.sum({g=>g.peso()})

	method golosinasFaltantes(golosinaDeseada) = golosinaDeseada.difference(bolsaGolosinas.asSet())
	method gustosFaltantes(gustosDeseados) = gustosDeseados.difference(self.sabores())

	method gastoEn(sabor) = bolsaGolosinas.filter({g=>g.gusto() == sabor}).sum({g=>g.pesos()})
	method saborPopular() = bolsaGolosinas.map({g=>g.gusto()}).max({g=>self.cantidadGolosinasDeUnSabor(g)})
	method cantidadGolosinasDeUnSabor(sabor) = bolsaGolosinas.filter({g=>g.gusto() == sabor}).size()
	method saborMasPesado() = bolsaGolosinas.map({g=> g.gusto()}).asSet().max({g=>self.pesoDeCadaSabor(g)})
	method pesoDeCadaSabor(sabor) = bolsaGolosinas.filter({g=>g.gusto() == sabor}).map({g=>g.peso()}).sum() 
	method comproYDesecho(golosina) = compradas.contains(golosina) && desechadas.contains(golosina)

	method baniar(unaGolosina) {
		if (unaGolosina.esBaniada()) {
			throw new Exception(message = "esta golosina ya esta baniada")
	}	else {
    		bolsaGolosinas.add(new GolosinaBaniada(golosinaInicial = unaGolosina))
		}
	}
}
