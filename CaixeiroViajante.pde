final int TELA_INICIO     = 0;
final int TELA_EXPLICACAO = 1;
final int TELA_SIMULACAO  = 2;
int telaAtual = TELA_INICIO;

int numCidades = 15;
int tamPopulacao = 150;
float taxaMutacao = 0.04;
int tamanhoTorneio = 5;
int passosPorFrame = 2;

ArrayList<PVector> cidades;
float[][] matrizDistancias;

ArrayList<int[]> populacao;
float[] fitness;
int[] melhorRotaGlobal;
int[] segundaMelhorRota;
float menorDistanciaGlobal = Float.MAX_VALUE;
float distanciaInicial = 0;

ArrayList<Float> historicoDistancias;
int geracao = 0;
boolean pausado = false;
boolean mostrarPesosRota = false;
int cidadeArrastada = -1;

void setup() {
  size(1180, 690);
  smooth(8);
  configurarTipografia();
  inicializarDecoracaoInicio();
  inicializarGrafo(numCidades);
  inicializarPopulacao();
  criarTodosBotoes();
}

void draw() {
  background(COR_FUNDO);
  desenharTexturaFundo();

  if (telaAtual == TELA_INICIO) {
    desenharTelaInicio();
  } else if (telaAtual == TELA_EXPLICACAO) {
    desenharTelaExplicacao();
  } else if (telaAtual == TELA_SIMULACAO) {
    if (!pausado && cidades.size() >= 3) {
      for (int s = 0; s < passosPorFrame; s++) {
        evoluirGeracao();
      }
    }
    desenharAreaGrafo();
    desenharPainelLateral();
  }
}

void mousePressed() {
  if (telaAtual == TELA_INICIO) {
    for (Botao b : botoesInicio) {
      if (b.estaSobre(mouseX, mouseY)) {
        executarAcaoBotao(b.id);
        return;
      }
    }
  } else if (telaAtual == TELA_EXPLICACAO) {
    for (Botao b : botoesExplicacao) {
      if (b.estaSobre(mouseX, mouseY)) {
        executarAcaoBotao(b.id);
        return;
      }
    }
  } else if (telaAtual == TELA_SIMULACAO) {
    for (Botao b : botoesSimulacao) {
      if (b.estaSobre(mouseX, mouseY)) {
        executarAcaoBotao(b.id);
        return;
      }
    }

    if (mouseX > 48 && mouseX < 726 && mouseY > 110 && mouseY < height - 48) {
      for (int i = 0; i < cidades.size(); i++) {
        if (dist(mouseX, mouseY, cidades.get(i).x, cidades.get(i).y) < 16) {
          if (mouseButton == LEFT) {
            cidadeArrastada = i;
          } else if (mouseButton == RIGHT) {
            cidades.remove(i);
            atualizarMatrizDistancias();
            inicializarPopulacao();
          }
          return;
        }
      }

      if (mouseButton == LEFT) {
        cidades.add(new PVector(mouseX, mouseY));
        atualizarMatrizDistancias();
        inicializarPopulacao();
      }
    }
  }
}

void mouseDragged() {
  if (telaAtual == TELA_SIMULACAO && cidadeArrastada != -1) {
    float nx = constrain(mouseX, 54, 720);
    float ny = constrain(mouseY, 114, height - 54);
    cidades.get(cidadeArrastada).set(nx, ny);
    atualizarMatrizDistancias();

    if (melhorRotaGlobal != null) {
      menorDistanciaGlobal = calcularDistanciaRota(melhorRotaGlobal);
    }
  }
}

void mouseReleased() {
  cidadeArrastada = -1;
}

void executarAcaoBotao(String id) {
  if (id.equals("ir_simulacao")) {
    telaAtual = TELA_SIMULACAO;
  } else if (id.equals("ir_explicacao")) {
    telaAtual = TELA_EXPLICACAO;
  } else if (id.equals("voltar_inicio")) {
    telaAtual = TELA_INICIO;
  } else if (id.equals("toggle_pesos")) {
    mostrarPesosRota = !mostrarPesosRota;
  } else if (id.equals("pausar")) {
    pausado = !pausado;
  } else if (id.equals("novo_grafo")) {
    inicializarGrafo(numCidades);
    inicializarPopulacao();
  } else if (id.equals("reiniciar_ag")) {
    inicializarPopulacao();
  } else if (id.equals("limpar")) {
    cidades.clear();
    inicializarPopulacao();
  } else if (id.equals("otimizar_2opt")) {
    aplicarBuscaLocal2Opt();
  } else if (id.equals("mut_mais")) {
    taxaMutacao = constrain(taxaMutacao + 0.01, 0.0, 0.5);
  } else if (id.equals("mut_menos")) {
    taxaMutacao = constrain(taxaMutacao - 0.01, 0.0, 0.5);
  } else if (id.equals("vel_mais")) {
    passosPorFrame = constrain(passosPorFrame + 1, 1, 20);
  } else if (id.equals("vel_menos")) {
    passosPorFrame = constrain(passosPorFrame - 1, 1, 20);
  }
}
