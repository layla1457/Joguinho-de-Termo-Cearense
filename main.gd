extends Control

# lista de palavras!!

var palavras_secretas : Array[String] = [
	"DIABO", "VISAO", "NOITE", "ALMAS", "BRUXA", "CERRA", "CORPO",
	"MATOS", "COURO", "EGUAS", "OXENT", "SUSTO", "MORTE", "SECAS", 
	"CHORO", "BAIAO", "DENTO", "DENTE", "UNHAS", "GRITO", "CORDA"
]

var palavra_certa : String = ""
var tentativaAtual : int = 0
const maxtentativas : int = 6
const tamanhopalavra : int = 5

@onready var grid_palavras : GridContainer = $"(UI) CanvasLayer/MarginContainer/VBoxContainer/GridPalavras"
@onready var line_edit : LineEdit = $"(UI) CanvasLayer/MarginContainer/VBoxContainer/LineEdit"
@onready var mensagem_resultado : Label = $"(UI) CanvasLayer/MarginContainer/VBoxContainer/MensagemResultado"
@onready var fogueira : AnimatedSprite2D = $Node2D/fogueiraplayer
@onready var jogador : AnimatedSprite2D = $"Node2D/jogador amarrado"
@onready var psicopata1 : AnimatedSprite2D = $Node2D/psicopata1
@onready var jogadorvenceu : AnimatedSprite2D = $"Node2D/jogador amarrado"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	psicopata1.play("default")
	fogueira.frame = 0
	#escolhe uma palavra aleatória aee
	randomize()
	palavra_certa = palavras_secretas.pick_random()
	
	mensagem_resultado.text = ""
	
	line_edit.text_submitted.connect(_on_line_edit_text_submitted)
	line_edit.grab_focus()


func _on_line_edit_text_submitted(novo_texto: String) -> void:
	var pal : String = novo_texto.strip_edges().to_upper()
	line_edit.text = ""
	
	#validação do tamanho da palavra ne
	
	if pal.length() != tamanhopalavra:
		mensagem_resultado.text = "A palavra deve ter 5 letras!"
		return
	if tentativaAtual >= maxtentativas:
		return 

	mensagem_resultado.text = ""
	processar_tentativa(pal)

func processar_tentativa(palavra : String) -> void:
	var inicio_index : int = tentativaAtual * tamanhopalavra
	
	for i in range(tamanhopalavra):
		var label_node : Label = grid_palavras.get_child(inicio_index + i) as Label
		var letra : String = palavra[i]

		label_node.text = letra
		
		#as regras de cores
		if letra == palavra_certa[i]:
			label_node.modulate = Color.GREEN 
		elif letra in palavra_certa:
			label_node.modulate = Color.YELLOW 
		else:
			label_node.modulate = Color.DARK_GRAY 
	
	tentativaAtual += 1
	
	if tentativaAtual == 4:
		psicopata1.play("com_gasolina")

	if palavra == palavra_certa:
		mensagem_resultado.text = "VOCÊ ESCAPOU! Os psicopatas do sertão te deixaram escapar."
		line_edit.editable = false
		jogadorvenceu.play("jogador_aliviado")
		psicopata1.play("default")
		
	elif tentativaAtual >= maxtentativas:
		mensagem_resultado.text = "VOCÊ FOI QUEIMADO VIVO! A palavra era: " + palavra_certa
		line_edit.editable = false
		fogueira.frame = 1
		psicopata1.play("default")
		await get_tree().create_timer(0.3).timeout
		jogador.play("pegando_fogo")
		await get_tree().create_timer(2.0).timeout
		fogueira.frame = 0
		jogador.play("queimado")
		
