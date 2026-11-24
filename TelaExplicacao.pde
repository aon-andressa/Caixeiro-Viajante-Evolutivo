
void desenharTelaExplicacao() {
  float margin = 42;
  float cardW = width - margin * 2;
  float cardH = height - margin * 2;

  desenharCartaoElevado(margin, margin, cardW, cardH, 28);

  textFont(fonteTitulo);
  textSize(26);
  fill(COR_TEXTO_TITULO);
  textAlign(LEFT, TOP);
  text("Fundamentos do Projeto", margin + 44, margin + 34);

  textFont(fonteSubtitulo);
  textSize(14.5);
  fill(COR_TEXTO_CORPO);
  text("Como a Teoria dos Grafos e a Computação Evolucionária resolvem o Problema do Caixeiro-Viajante.", margin + 44, margin + 70);

  float boxW = (cardW - 116) / 2;
  float boxH = 198;
  float col1 = margin + 44;
  float col2 = col1 + boxW + 28;
  float row1 = margin + 116;
  float row2 = row1 + boxH + 22;

  desenharCardExplicacao(col1, row1, boxW, boxH, "01",
    "Modelagem com Grafos",
    "Cada cidade representa um vértice no plano bidimensional.\n" +
    "Todas conectam-se formando um Grafo Completo ponderado,\n" +
    "onde o peso das arestas equivale à distância euclidiana.\n" +
    "Busca-se o Ciclo Hamiltoniano de menor soma de pesos.");

  desenharCardExplicacao(col2, row1, boxW, boxH, "02",
    "Cromossomos & Aptidão",
    "Cada solução candidata é codificada como uma permutação\n" +
    "dos vértices (ex.: [1, 4, 2, 5, 3]), evitando visitas repetidas.\n" +
    "A função de aptidão (fitness) é inversamente proporcional à\n" +
    "distância total: rotas mais curtas têm maior chance de seleção.");

  desenharCardExplicacao(col1, row2, boxW, boxH, "03",
    "Operadores Genéticos",
    "• Torneio: seleciona os melhores indivíduos entre k competidores.\n" +
    "• Cruzamento Ordenado (OX1): combina segmentos de dois pais\n" +
    "  sem duplicar cidades na permutação.\n" +
    "• Mutação por Troca (Swap) e Elitismo do melhor percurso.");

  desenharCardExplicacao(col2, row2, boxW, boxH, "04",
    "Interação em Tempo Real",
    "• Passe o mouse sobre um vértice para inspecionar os pesos.\n" +
    "• Clique no mapa para criar vértices ou arraste para mover.\n" +
    "• Botão direito sobre um vértice remove a cidade do grafo.\n" +
    "• 'Desembaraçar (2-Opt)' aplica refinamento local instantâneo.");

  for (Botao b : botoesExplicacao) {
    b.desenhar();
  }
}

void desenharCardExplicacao(float x, float y, float w, float h, String num, String titulo, String corpo) {
  fill(COR_CARD_INTERNO);
  stroke(COR_BORDA_SUTIL);
  strokeWeight(1.2);
  rect(x, y, w, h, 18);

  fill(COR_PRIMARIA, 30);
  noStroke();
  rect(x + 20, y + 18, 34, 24, 8);
  textFont(fonteMono);
  textSize(12);
  fill(COR_PRIMARIA);
  textAlign(CENTER, CENTER);
  text(num, x + 37, y + 29);

  textFont(fonteSubtitulo);
  textSize(16);
  fill(COR_TEXTO_TITULO);
  textAlign(LEFT, CENTER);
  text(titulo, x + 64, y + 29);

  textFont(fonteCorpo);
  textSize(13);
  textLeading(21);
  fill(COR_TEXTO_CORPO);
  textAlign(LEFT, TOP);
  text(corpo, x + 20, y + 56);
}
