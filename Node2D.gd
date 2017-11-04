extends Node2D

# constantes
const START_TREASURY = 20000
const START_PRICE = 300
const START_EMPLOYEES = 2
const START_SALARY = 1000
const START_STOCK = 0

# variables de classes (attributs)
var current_turn = 1
var current_treasury = START_TREASURY
var monthly_clients = 23
var current_price = START_PRICE
var current_employees = START_EMPLOYEES
var current_salary = START_SALARY
var current_stock = START_STOCK
var raw_material_nodes = []
var last_turnover = null
var last_sold = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	update_infos()
	update_employees()
	update_salary()
	raw_material_nodes = [get_node("MatierePremiere1"), get_node("MatierePremiere2"), get_node("MatierePremiere3")]
	raw_material_nodes[0].initialize("Matière 1", 50)
	raw_material_nodes[1].initialize("Matière 2", 75)
	raw_material_nodes[2].initialize("Matière 3", 100)
	
func update_infos():
	# Trésorerie
	get_node("GridContainerInfos/GridContainer/LineEditTreso").set_text(str(current_treasury))
	# Stock
	get_node("GridContainerInfos/GridContainer/LineEditStock").set_text(str(current_stock))
	# Prix
	get_node("GridContainerInfos/GridContainer/LineEditPrice").set_text(str(current_price))
	# Infos mois dernier
	var label_last_month = get_node("GridContainerInfos/LabelMoisDernier")
	if (last_turnover != null) and (last_sold != null):
		label_last_month.set_text("Mois dernier :\nUnités vendues : " + str(last_sold) + "\nCA : " + str(last_turnover))
	else:
		label_last_month.set_text("")
	
func update_employees():
	get_node("HBAEmployees").set_selected(1)
	get_node("HBAEmployees").set_button_text(1, str(current_employees) + " salariés")
	
func update_salary():
	get_node("SpinBoxSalary").set_val(current_salary)

# Fabrication des unités
func make_units():
	# A unit takes 2 of matière première 1 and 1 of each other
	var max_units = min(int(raw_material_nodes[0].stock() / 2), min(raw_material_nodes[1].stock(), raw_material_nodes[2].stock()))
	# One employee can only make 5 units a month
	max_units = min(max_units, current_employees * 5)
	raw_material_nodes[0].use_stock(max_units * 2)
	raw_material_nodes[1].use_stock(max_units)
	raw_material_nodes[2].use_stock(max_units)
	current_stock += max_units

# Calcul des unités vendues
func calculate_sold():
	var max_units = min(monthly_clients, current_stock)
	return max_units

# Calcul du CA
func calculate_turnover(sold):
	var turnover = sold * current_price
	return turnover

# Calcul des coûts
func calculate_costs():
	var cost = current_employees * current_salary
	for raw_material_node in raw_material_nodes:
		cost += raw_material_node.cost()
	return cost
	
func next_turn():
	# Calcul des unités vendues
	make_units()
	last_sold = calculate_sold()
	current_stock -= last_sold
	# CA du mois
	var monthly_turnover = calculate_turnover(last_sold)
	# charges
	var monthly_costs = calculate_costs()
	last_turnover = monthly_turnover
	# Calcul de la trésorerie
	current_treasury += monthly_turnover - monthly_costs
	# Évolution du nombre d'employés
	var employees_choice = get_node("HBAEmployees").get_selected()
	# Si on a sélectionné le bouton "+"
	if (employees_choice == 2):
		current_employees += 1
	# Si on a sélectionné le bouton "-"
	elif ((employees_choice == 0) and (current_employees > 0)):
		current_employees -= 1
	# Évolution des stocks
	for raw_material_node in raw_material_nodes:
		raw_material_node.buy()
	# Affichage variables
	update_employees()
	update_infos()
	update_salary()
	# Affichage tour
	current_turn += 1
	get_node("LabelTour").set_text("Mois " + str(current_turn))

func set_salary(n):
	current_salary = int(n)