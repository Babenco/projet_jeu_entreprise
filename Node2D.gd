extends Node2D

# constantes
var START_TREASURY = 20000
var START_PRICE = 12
var START_EMPLOYEES = 2
var START_SALARY = 1000

# variables de classes (attributs)
var current_turn = 1
var current_treasury = START_TREASURY
var monthly_clients = 700
var current_price = START_PRICE
var current_employees = START_EMPLOYEES
var current_salary = START_SALARY

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	update_treasury()
	update_employees()
	
func update_treasury():
	get_node("LabelTreso").set_text("Trésorerie : " + str(current_treasury))
	
func update_employees():
	get_node("HSliderEmployees").set_value(current_employees)
	get_node("LabelEmployees").set_text("Employés : " + str(current_employees))
	
func next_turn():
	# CA du mois
	var monthly_turnover = monthly_clients * current_price
	# charges
	var monthly_costs = current_employees * current_salary
	# Calcul de la trésorerie
	current_treasury += monthly_turnover - monthly_costs
	# Affichage variables
	update_employees()
	update_treasury()
	# Affichage tour
	current_turn += 1
	get_node("LabelTour").set_text("Tour " + str(current_turn))
	
func set_employees(n):
	current_employees = int(n)
	update_employees()
