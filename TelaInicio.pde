ArrayList<PVector> nosDecorativos;
ArrayList<PVector> velDecorativas;

void inicializarDecoracaoInicio() {
  nosDecorativos = new ArrayList<PVector>();
  velDecorativas = new ArrayList<PVector>();
  for (int i = 0; i < 24; i++) {
    nosDecorativos.add(new PVector(random(width), random(height)));
    velDecorativas.add(new PVector(random(-0.4, 0.4), random(-0.4, 0.4)));
  }
}

void desenharTelaInicio() {
  for (int i = 0; i < nosDecorativos.size(); i++) {
    PVector p = nosDecorativos.get(i);
    PVector v = velDecorativas.get(i);
    p.add(v);
    if (p.x < 0 || p.x > width) v.x *= -1;
    if (p.y < 0 || p.y > height) v.y *= -1;
  }

  for (int i = 0; i < nosDecorativos.size(); i++) {
    for (int j = i + 1; j < nosDecorativos.size(); j++) {
      float d = PVector.dist(nosDecorativos.get(i), nosDecorativos.get(j));
      if (d < 220) {
        stroke(COR_ROTA_SEC, map(d, 0, 220, 160, 0));
        strokeWeight(1.4);
        line(nosDecorativos.get(i).x, nosDecorativos.get(i).y, nosDecorativos.get(j).x, nosDecorativos.get(j).y);
      }
    }
  }

  for (int i = 0; i < nosDecorativos.size(); i++) {
    PVector p = nosDecorativos.get(i);
    noStroke();
    fill(COR_NO_CIDADE, 55);
    ellipse(p.x, p.y, 18, 18);
    fill(COR_PRIMARIA, 150);
    ellipse(p.x, p.y, 7, 7);
  }

  float cardW = 640;
  float cardH = 400;
  float cardX = (width - cardW) / 2;
  float cardY = (height - cardH) / 2;

  desenharCartaoElevado(cardX, cardY, cardW, cardH, 32);

  fill(COR_BOTAO_SEC);
  noStroke();
  rect(width / 2 - 155, cardY + 42, 310, 30, 15);
  
  textFont(fonteCorpo);
  textSize(11.5);
  fill(COR_PRIMARIA);
  textAlign(CENTER, CENTER);
  text("COMPUTAÇÃO EVOLUCIONÁRIA  •  TEORIA DOS GRAFOS", width / 2, cardY + 56);

  textFont(fonteTitulo);
  textSize(34);
  fill(COR_TEXTO_TITULO);
  text("Caixeiro-Viajante Evolutivo", width / 2, cardY + 114);

  stroke(COR_BORDA_SUTIL);
  strokeWeight(2);
  line(width / 2 - 40, cardY + 146, width / 2 + 40, cardY + 146);

  textFont(fonteSubtitulo);
  textSize(15);
  textLeading(23);
  fill(COR_TEXTO_CORPO);
  text("Explore a otimização de Ciclos Hamiltonianos em grafos\nponderados através de um Algoritmo Genético interativo.", width / 2, cardY + 186);

  for (Botao b : botoesInicio) {
    b.desenhar();
  }
}
