
color COR_FUNDO         = color(252, 245, 247);
color COR_PAINEL        = color(255, 252, 253);
color COR_CARD_INTERNO  = color(250, 240, 244);
color COR_BORDA_SUTIL   = color(240, 212, 223);
color COR_SOMBRA        = color(218, 178, 194);

color COR_TEXTO_TITULO  = color(74, 48, 61);
color COR_TEXTO_CORPO   = color(122, 90, 105);
color COR_TEXTO_SUAVE   = color(168, 136, 150);

color COR_ARESTA_FUNDO  = color(226, 188, 204);
color COR_ARESTA_HOVER  = color(214, 138, 168);
color COR_ROTA_SEC      = color(236, 168, 194);
color COR_PRIMARIA      = color(226, 98, 138);
color COR_PRIMARIA_HOVER= color(212, 82, 122);
color COR_DESTAQUE_OURO = color(235, 162, 114);
color COR_NO_CIDADE     = color(232, 132, 165);

color COR_BOTAO_SEC     = color(248, 233, 239);
color COR_BOTAO_HOVER   = color(242, 214, 225);

PFont fonteTitulo, fonteSubtitulo, fonteCorpo, fonteMono;
ArrayList<Botao> botoesInicio;
ArrayList<Botao> botoesExplicacao;
ArrayList<Botao> botoesSimulacao;

void configurarTipografia() {
  String[] listaFontes = PFont.list();
  String familiaSans = "SansSerif";
  String familiaMono = "Monospaced";

  for (String f : listaFontes) {
    if (f.equals("Segoe UI") || f.equals("Helvetica Neue") || f.equals("Arial")) {
      familiaSans = f;
      break;
    }
  }
  for (String f : listaFontes) {
    if (f.equals("Consolas") || f.equals("Menlo") || f.equals("Courier New")) {
      familiaMono = f;
      break;
    }
  }

  fonteTitulo    = createFont(familiaSans, 32, true);
  fonteSubtitulo = createFont(familiaSans, 16, true);
  fonteCorpo     = createFont(familiaSans, 13.5, true);
  fonteMono      = createFont(familiaMono, 15, true);
}

void desenharTexturaFundo() {
  noStroke();
  fill(245, 214, 226, 45);
  ellipse(180, 140, 520, 520);
  fill(248, 222, 214, 40);
  ellipse(width - 160, height - 120, 560, 560);
}

void desenharAreaGrafo() {
  desenharCartaoElevado(26, 26, 722, height - 52, 24);

  textFont(fonteTitulo);
  textSize(21);
  fill(COR_TEXTO_TITULO);
  textAlign(LEFT, CENTER);
  text("Grafo Ponderado & Ciclo Ótimo", 54, 58);

  textFont(fonteCorpo);
  textSize(12.5);
  fill(COR_TEXTO_SUAVE);
  text("Passe o mouse nos vértices para ver pesos  •  Clique para adicionar  •  Arraste para mover", 54, 84);

  desenharLegendaGrafo(465, 58);

  int n = cidades.size();
  if (n < 3) {
    textFont(fonteSubtitulo);
    textSize(15);
    fill(COR_PRIMARIA);
    textAlign(CENTER, CENTER);
    text("Clique no quadro rosado para adicionar pelo menos 3 cidades", 387, height / 2);
    return;
  }

  int noHover = -1;
  for (int i = 0; i < n; i++) {
    if (dist(mouseX, mouseY, cidades.get(i).x, cidades.get(i).y) < 16) {
      noHover = i;
      break;
    }
  }

  for (int i = 0; i < n; i++) {
    for (int j = i + 1; j < n; j++) {
      boolean incidenteNoHover = (noHover == i || noHover == j);
      if (incidenteNoHover) {
        stroke(COR_ARESTA_HOVER, 210);
        strokeWeight(1.8);
      } else {
        stroke(COR_ARESTA_FUNDO, 175);
        strokeWeight(1.25);
      }
      line(cidades.get(i).x, cidades.get(i).y, cidades.get(j).x, cidades.get(j).y);
    }
  }

  if (segundaMelhorRota != null && segundaMelhorRota.length == n) {
    stroke(COR_ROTA_SEC, 140);
    strokeWeight(2);
    noFill();
    beginShape();
    for (int idx : segundaMelhorRota) {
      vertex(cidades.get(idx).x, cidades.get(idx).y);
    }
    endShape(CLOSE);
  }

  if (melhorRotaGlobal != null && melhorRotaGlobal.length == n) {
    stroke(COR_PRIMARIA, 48);
    strokeWeight(11);
    strokeJoin(ROUND);
    noFill();
    beginShape();
    for (int idx : melhorRotaGlobal) {
      vertex(cidades.get(idx).x, cidades.get(idx).y);
    }
    endShape(CLOSE);

    stroke(COR_PRIMARIA);
    strokeWeight(3.4);
    beginShape();
    for (int idx : melhorRotaGlobal) {
      vertex(cidades.get(idx).x, cidades.get(idx).y);
    }
    endShape(CLOSE);

    for (int i = 0; i < n; i++) {
      int u = melhorRotaGlobal[i];
      int v = melhorRotaGlobal[(i + 1) % n];
      PVector a = cidades.get(u);
      PVector b = cidades.get(v);
      desenharIndicadorDirecao(a, b);

      if (mostrarPesosRota && noHover == -1) {
        desenharEtiquetaPeso(a, b, matrizDistancias[u][v], true);
      }
    }
  }

  
  if (noHover != -1) {
    PVector origem = cidades.get(noHover);
    for (int j = 0; j < n; j++) {
      if (j == noHover) continue;
      desenharEtiquetaPeso(origem, cidades.get(j), matrizDistancias[noHover][j], false);
    }
  }

  // Vértices
  for (int i = 0; i < n; i++) {
    PVector c = cidades.get(i);
    boolean ehInicio = (melhorRotaGlobal != null && melhorRotaGlobal.length > 0 && i == melhorRotaGlobal[0]);
    boolean hover = (i == noHover);

    color corBase = ehInicio ? COR_DESTAQUE_OURO : COR_NO_CIDADE;

    if (ehInicio) {
      float pulso = 30 + sin(frameCount * 0.07) * 5;
      noStroke();
      fill(corBase, 65);
      ellipse(c.x, c.y, pulso, pulso);
    } else if (hover) {
      noStroke();
      fill(corBase, 75);
      ellipse(c.x, c.y, 32, 32);
    }

    fill(255);
    stroke(COR_PRIMARIA, 140);
    strokeWeight(1.5);
    float diam = hover ? 24 : (ehInicio ? 23 : 20);
    ellipse(c.x, c.y, diam, diam);

    noStroke();
    fill(corBase);
    ellipse(c.x, c.y, diam - 5, diam - 5);

    textFont(fonteMono);
    textSize(10);
    fill(255);
    textAlign(CENTER, CENTER);
    text(i + 1, c.x, c.y - 0.5);
  }
}

void desenharEtiquetaPeso(PVector a, PVector b, float peso, boolean destaqueRota) {
  PVector meio = PVector.lerp(a, b, 0.5);
  String txt = nf(peso, 1, 0);

  textFont(fonteMono);
  textSize(9.5);
  float tw = textWidth(txt) + 10;
  float th = 16;

  fill(destaqueRota ? COR_PRIMARIA : color(255, 250, 252, 235));
  stroke(destaqueRota ? COR_PRIMARIA : COR_ARESTA_HOVER);
  strokeWeight(1);
  rect(meio.x - tw / 2, meio.y - th / 2, tw, th, 8);

  fill(destaqueRota ? color(255) : COR_TEXTO_TITULO);
  textAlign(CENTER, CENTER);
  text(txt, meio.x, meio.y - 0.5);
}

void desenharLegendaGrafo(float x, float y) {
  stroke(COR_ARESTA_FUNDO);
  strokeWeight(2);
  line(x - 52, y, x - 34, y);
  fill(COR_TEXTO_SUAVE);
  textFont(fonteCorpo);
  textSize(11);
  textAlign(LEFT, CENTER);
  text("Aresta", x - 30, y - 1);

  noStroke();
  fill(COR_DESTAQUE_OURO);
  ellipse(x + 20, y, 9, 9);
  fill(COR_TEXTO_SUAVE);
  text("Origem", x + 29, y - 1);

  fill(COR_NO_CIDADE);
  ellipse(x + 82, y, 9, 9);
  fill(COR_TEXTO_SUAVE);
  text("Vértice", x + 91, y - 1);
}

void desenharIndicadorDirecao(PVector a, PVector b) {
  float d = PVector.dist(a, b);
  if (d < 50) return;
  PVector meio = PVector.lerp(a, b, 0.28);
  float angulo = atan2(b.y - a.y, b.x - a.x);

  pushMatrix();
  translate(meio.x, meio.y);
  rotate(angulo);
  noStroke();
  fill(COR_PRIMARIA);
  triangle(4.5, 0, -3.5, -3.5, -3.5, 3.5);
  popMatrix();
}

void desenharPainelLateral() {
  float px = 768;
  float pw = width - px - 26;

  desenharCartaoElevado(px, 26, pw, height - 52, 24);

  textFont(fonteTitulo);
  textSize(19);
  fill(COR_TEXTO_TITULO);
  textAlign(LEFT, CENTER);
  text("Métricas Evolutivas", px + 24, 58);

  desenharCardMetrica(px + 24, 92, 162, 64, "GERAÇÃO ATUAL", nf(geracao, 0), COR_TEXTO_TITULO);
  desenharCardMetrica(px + 198, 92, 162, 64, "VÉRTICES (CIDADES)", nf(cidades.size(), 0), COR_TEXTO_TITULO);

  float ganho = (distanciaInicial > 0) ? max(0, (1 - (menorDistanciaGlobal / distanciaInicial)) * 100) : 0;
  String distTexto = (cidades.size() >= 3) ? nf(menorDistanciaGlobal, 1, 1) + " px" : "--";
  String ganhoTexto = (cidades.size() >= 3) ? "redução de " + nf(ganho, 1, 0) + "%" : "";
  desenharCardMetricaDestaque(px + 24, 168, 336, 68, "CUSTO DO CICLO ÓTIMO", distTexto, ganhoTexto);

  desenharGraficoConvergencia(px + 24, 250, 336, 165);

  desenharControlePilula(px + 24, 432, 162, "MUTAÇÃO", nf(taxaMutacao * 100, 1, 0) + "%");
  desenharControlePilula(px + 198, 432, 162, "VELOCIDADE", passosPorFrame + "x");

  for (Botao b : botoesSimulacao) {
    b.desenhar();
  }
}

void desenharCardMetrica(float x, float y, float w, float h, String titulo, String valor, color corValor) {
  fill(COR_CARD_INTERNO);
  stroke(COR_BORDA_SUTIL);
  strokeWeight(1.2);
  rect(x, y, w, h, 14);

  textFont(fonteCorpo);
  textSize(10);
  fill(COR_TEXTO_SUAVE);
  textAlign(LEFT, TOP);
  text(titulo, x + 14, y + 11);

  textFont(fonteMono);
  textSize(19);
  fill(corValor);
  text(valor, x + 14, y + 30);
}

void desenharCardMetricaDestaque(float x, float y, float w, float h, String titulo, String valor, String subtexto) {
  fill(COR_CARD_INTERNO);
  stroke(COR_BORDA_SUTIL);
  strokeWeight(1.2);
  rect(x, y, w, h, 14);

  textFont(fonteCorpo);
  textSize(10);
  fill(COR_TEXTO_SUAVE);
  textAlign(LEFT, TOP);
  text(titulo, x + 14, y + 11);

  textFont(fonteMono);
  textSize(20);
  fill(COR_PRIMARIA);
  text(valor, x + 14, y + 31);

  if (subtexto.length() > 0) {
    textFont(fonteCorpo);
    textSize(11.5);
    fill(COR_TEXTO_CORPO);
    textAlign(RIGHT, CENTER);
    text(subtexto, x + w - 14, y + 42);
  }
}

void desenharControlePilula(float x, float y, float w, String label, String valorAtual) {
  textFont(fonteCorpo);
  textSize(10);
  fill(COR_TEXTO_SUAVE);
  textAlign(LEFT, TOP);
  text(label, x + 4, y);

  fill(COR_CARD_INTERNO);
  stroke(COR_BORDA_SUTIL);
  strokeWeight(1.2);
  rect(x, y + 16, w, 34, 12);

  textFont(fonteMono);
  textSize(13.5);
  fill(COR_TEXTO_TITULO);
  textAlign(CENTER, CENTER);
  text(valorAtual, x + w / 2, y + 32);
}

void desenharGraficoConvergencia(float x, float y, float w, float h) {
  fill(COR_CARD_INTERNO);
  stroke(COR_BORDA_SUTIL);
  strokeWeight(1.2);
  rect(x, y, w, h, 16);

  textFont(fonteCorpo);
  textSize(11);
  fill(COR_TEXTO_SUAVE);
  textAlign(LEFT, TOP);
  text("CURVA DE CONVERGÊNCIA", x + 16, y + 12);

  stroke(COR_BORDA_SUTIL, 140);
  strokeWeight(1);
  for (int i = 1; i <= 3; i++) {
    float ly = map(i, 0, 4, y + 36, y + h - 16);
    line(x + 16, ly, x + w - 16, ly);
  }

  int total = historicoDistancias.size();
  if (total < 2) return;

  float maxD = historicoDistancias.get(0);
  float minD = historicoDistancias.get(total - 1);
  if (maxD - minD < 1) maxD = minD + 1;

  fill(COR_PRIMARIA, 32);
  noStroke();
  beginShape();
  vertex(x + 16, y + h - 16);
  for (int i = 0; i < total; i++) {
    float gx = map(i, 0, total - 1, x + 16, x + w - 16);
    float gy = map(historicoDistancias.get(i), minD, maxD, y + h - 20, y + 38);
    vertex(gx, gy);
  }
  vertex(x + w - 16, y + h - 16);
  endShape(CLOSE);

  stroke(COR_PRIMARIA);
  strokeWeight(2.4);
  noFill();
  beginShape();
  float ultimoX = 0, ultimoY = 0;
  for (int i = 0; i < total; i++) {
    ultimoX = map(i, 0, total - 1, x + 16, x + w - 16);
    ultimoY = map(historicoDistancias.get(i), minD, maxD, y + h - 20, y + 38);
    vertex(ultimoX, ultimoY);
  }
  endShape();

  noStroke();
  fill(COR_PRIMARIA, 70);
  ellipse(ultimoX, ultimoY, 12, 12);
  fill(COR_PRIMARIA);
  ellipse(ultimoX, ultimoY, 6, 6);
}

void desenharCartaoElevado(float x, float y, float w, float h, float raio) {
  noStroke();
  fill(COR_SOMBRA, 22);
  rect(x + 2, y + 8, w, h, raio);
  fill(COR_SOMBRA, 14);
  rect(x + 4, y + 14, w, h, raio);

  fill(COR_PAINEL, 250);
  stroke(COR_BORDA_SUTIL);
  strokeWeight(1.5);
  rect(x, y, w, h, raio);
}

void criarTodosBotoes() {
  botoesInicio = new ArrayList<Botao>();
  float btnW = 290;
  float btnH = 48;
  float cx = width / 2 - btnW / 2;
  botoesInicio.add(new Botao("ir_simulacao", "Iniciar Simulação", cx, 368, btnW, btnH, true));
  botoesInicio.add(new Botao("ir_explicacao", "Como Funciona", cx, 428, btnW, btnH, false));

  botoesExplicacao = new ArrayList<Botao>();
  botoesExplicacao.add(new Botao("voltar_inicio", "← Voltar ao Início", 86, height - 106, 200, 44, false));
  botoesExplicacao.add(new Botao("ir_simulacao", "Ir para Simulação →", width - 306, height - 106, 220, 44, true));

  botoesSimulacao = new ArrayList<Botao>();
  float px = 792;

  botoesSimulacao.add(new Botao("toggle_pesos", "Pesos", 632, 43, 86, 30, false));
  botoesSimulacao.add(new Botao("voltar_inicio", "Início", px + 264, 43, 72, 30, false));

  botoesSimulacao.add(new Botao("mut_menos", "−", px + 4, 451, 34, 28, false));
  botoesSimulacao.add(new Botao("mut_mais", "+", px + 124, 451, 34, 28, false));

  botoesSimulacao.add(new Botao("vel_menos", "−", px + 178, 451, 34, 28, false));
  botoesSimulacao.add(new Botao("vel_mais", "+", px + 298, 451, 34, 28, false));

  botoesSimulacao.add(new Botao("pausar", "Pausar / Continuar", px, 498, 336, 40, true));
  botoesSimulacao.add(new Botao("novo_grafo", "Novo Grafo", px, 548, 162, 38, false));
  botoesSimulacao.add(new Botao("reiniciar_ag", "Reiniciar Rotas", px + 174, 548, 162, 38, false));
  botoesSimulacao.add(new Botao("otimizar_2opt", "Desembaraçar (2-Opt)", px, 596, 224, 38, false));
  botoesSimulacao.add(new Botao("limpar", "Limpar", px + 234, 596, 102, 38, false));
}

class Botao {
  String id, rotulo;
  float x, y, w, h;
  boolean destaque;

  Botao(String id, String rotulo, float x, float y, float w, float h, boolean destaque) {
    this.id = id;
    this.rotulo = rotulo;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.destaque = destaque;
  }

  boolean estaSobre(float mx, float my) {
    return mx >= x && mx <= x + w && my >= y && my <= y + h;
  }

  void desenhar() {
    boolean hover = estaSobre(mouseX, mouseY);
    boolean ativo = id.equals("toggle_pesos") && mostrarPesosRota;
    float raio = min(14, h / 2.2);

    if (destaque || ativo) {
      noStroke();
      fill(COR_PRIMARIA, hover ? 65 : 40);
      rect(x, y + 3, w, h, raio);

      fill(hover ? COR_PRIMARIA_HOVER : COR_PRIMARIA);
      rect(x, y, w, h, raio);
      fill(255);
    } else {
      fill(hover ? COR_BOTAO_HOVER : COR_BOTAO_SEC);
      stroke(COR_BORDA_SUTIL);
      strokeWeight(1.2);
      rect(x, y, w, h, raio);
      fill(COR_TEXTO_TITULO);
    }

    textFont(fonteCorpo);
    textSize(13.5);
    textAlign(CENTER, CENTER);
    text(rotulo, x + w / 2, y + h / 2 - 1);
  }
}
