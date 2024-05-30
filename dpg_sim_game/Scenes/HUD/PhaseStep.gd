extends Sprite

func ActiveStep():
	$Color.color = Color.yellow

func CompleteStep():
	$Color.color = Color.green

func EmptyStep():
	$Color.color = Color.white
