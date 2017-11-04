extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var DEFAULT_PRICE = 50
var DEFAULT_STOCK = 0

var name = "Matière première"
var price = DEFAULT_PRICE
var stock = DEFAULT_STOCK

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func initialize(new_name, new_price):
	name = new_name
	price = new_price
	get_node("LabelName").set_text(name)
	get_node("LineEditPrice").set_text(str(price))
	update_stock()
	
func stock():
	return stock
	
func use_stock(used_stock):
	stock -= used_stock

func update_stock():
	get_node("LineEditStock").set_text(str(stock))

# Renvoie le coût
func cost():
	return int(get_node("SpinBoxBuy").get_val())

# Effectue l'achat
func buy():
	var buy_node = get_node("SpinBoxBuy")
	var buy_count = int(buy_node.get_val())
	stock += buy_count
	update_stock()
	# Remet le nombre d'unités à acheter à zéro
	# buy_node.set_val(0)