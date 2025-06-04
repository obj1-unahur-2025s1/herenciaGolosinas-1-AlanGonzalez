/*
 * Los sabores
 */
object frutilla { }
object chocolate { }
object vainilla { }
object naranja { }
object limon { }


/*
 * Golosinas
 */
class Golosinas{
	var peso= 15
	var property libreGluten= false
	method peso() = peso
	method calcularEspacio(estanteria) = peso + 25 < estanteria.lugarDisponible() 
	method enOferta() = self.precio() < 10
	method precio() 
}
class Bombon inherits Golosinas(libreGluten= true){
	override method precio() { return 6 }
	method mordisco() { peso = peso * 0.8 - 1 }
	method sabor() { return frutilla }
	
}

class BombonDuro inherits Bombon{
	override method mordisco() {
		peso= peso - 1
	}
	method gradoDureza(){
	 if(peso > 12) 
	 	3 
	 else 
	 	if (peso.between(8,12)) 
			2 
	 else 
		1
	}
}



class Alfajor inherits Golosinas{
	override method precio() = 12
	method mordisco() { peso = peso * 0.8 }
	method sabor() { return chocolate }
}

class Caramelo inherits Golosinas(peso= 5, libreGluten= true) {
	var property sabor= frutilla
	override method precio() { return peso * 17 }
	method mordisco() { peso = peso - 1.2 }
	
	
}

class CarameloCorazon inherits Caramelo {
	override method mordisco() { //si el metodo lleva param
		super() // aca tambien
		sabor= chocolate
	}
	override method precio() = super() + 1 
}


class Chupetin inherits Golosinas(peso= 7, libreGluten= true) {
	override method precio() { return 2 }
	method mordisco() { 
		if (peso >= 2) {
			peso = peso * 0.9
		}
	}
	method sabor() { return naranja }

}

class Oblea inherits Golosinas(peso= 250) {
	override method precio() { return 5 }
	method mordisco() {
		peso= peso*(1- self.tamañoMordisco())
		
	}
	method tamañoMordisco(){
		if (peso >= 70) {
			// el peso pasa a ser la mitad
			 return 0.5
		} else { 
			// pierde el 25% del peso
			 return 0.25
		}
	}
	method sabor() { return vainilla }
}

class Chocolatin inherits Golosinas{
	// hay que acordarse de *dos* cosas, el peso inicial y el peso actual
	// el precio se calcula a partir del precio inicial
	// el mordisco afecta al peso actual
	var comido = 0
	override method precio() { return peso * 0.50 }
	override method peso() { return (peso - comido).max(0) }
	method mordisco() { comido = comido + 2 }
	method sabor() { return chocolate }

}

class GolosinaBaniada {
	var golosinaInterior
	var pesoBanio = 4
	
	method golosinaInterior(unaGolosina) { golosinaInterior = unaGolosina }
	method precio() { return golosinaInterior.precio() + 2 }
	method peso() { return golosinaInterior.peso() + pesoBanio }
	method mordisco() {
		golosinaInterior.mordisco()
		pesoBanio = (pesoBanio - 2).max(0) 
	}	
	method sabor() { return golosinaInterior.sabor() }
	method libreGluten() { return golosinaInterior.libreGluten() }	
}


class Tuttifrutti {
	var libreDeGluten
	const sabores = [frutilla, chocolate, naranja]
	var saborActual = 0
	
	method mordisco() { saborActual += 1 }	
	method sabor() { return sabores.get(saborActual % 3) }	

	method precio() { return (if(self.libreGluten()) 7 else 10) }
	method peso() { return 5 }
	method libreGluten() { return libreDeGluten }	
	method libreGluten(valor) { libreDeGluten = valor }
}