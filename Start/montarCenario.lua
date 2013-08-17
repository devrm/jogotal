local fundo = display.newImage("fundo.png")
fundo.x = 285; fundo.y = 160

local chao = display.newImage("ground.png")
chao.x = 0; chao.y = 320

physics.addBody(chao, "static", {friction=0.5, bounce=0})


local paredeEsquerda = display.newRect(0,0,1,display.contentHeight)
physics.addBody(paredeEsquerda, "static", {friction=0, bounce=0})

local paredeDireita = display.newRect(display.contentWidth,0,1,display.contentHeight)
physics.addBody(paredeDireita, "static", {friction=0, bounce=0})
