void inicializarPopulacao() {
  int n = cidades.size();
  populacao = new ArrayList<int[]>();
  fitness = new float[tamPopulacao];
  historicoDistancias = new ArrayList<Float>();
  geracao = 0;
  menorDistanciaGlobal = Float.MAX_VALUE;
  melhorRotaGlobal = null;
  segundaMelhorRota = null;

  if (n < 3) return;

  int[] base = new int[n];
  for (int i = 0; i < n; i++) base[i] = i;

  for (int i = 0; i < tamPopulacao; i++) {
    int[] cromossomo = base.clone();
    embaralhar(cromossomo);
    populacao.add(cromossomo);
  }
  avaliarPopulacao();
  distanciaInicial = menorDistanciaGlobal;
}

void avaliarPopulacao() {
  float segundaMenor = Float.MAX_VALUE;

  for (int i = 0; i < tamPopulacao; i++) {
    int[] rota = populacao.get(i);
    float dist = calcularDistanciaRota(rota);
    fitness[i] = 1.0 / (dist + 0.0001);

    if (dist < menorDistanciaGlobal) {
      segundaMenor = menorDistanciaGlobal;
      segundaMelhorRota = (melhorRotaGlobal != null) ? melhorRotaGlobal.clone() : rota.clone();
      menorDistanciaGlobal = dist;
      melhorRotaGlobal = rota.clone();
    } else if (dist < segundaMenor && dist > menorDistanciaGlobal) {
      segundaMenor = dist;
      segundaMelhorRota = rota.clone();
    }
  }
  historicoDistancias.add(menorDistanciaGlobal);
}

void evoluirGeracao() {
  ArrayList<int[]> novaPopulacao = new ArrayList<int[]>();
  novaPopulacao.add(melhorRotaGlobal.clone());

  while (novaPopulacao.size() < tamPopulacao) {
    int[] pai1 = selecaoTorneio();
    int[] pai2 = selecaoTorneio();
    int[] filho = cruzamentoOrdenado(pai1, pai2);
    mutacaoTroca(filho);
    novaPopulacao.add(filho);
  }

  populacao = novaPopulacao;
  geracao++;
  avaliarPopulacao();
}

int[] selecaoTorneio() {
  int melhorIndice = int(random(tamPopulacao));
  float melhorFit = fitness[melhorIndice];
  for (int i = 1; i < tamanhoTorneio; i++) {
    int idx = int(random(tamPopulacao));
    if (fitness[idx] > melhorFit) {
      melhorFit = fitness[idx];
      melhorIndice = idx;
    }
  }
  return populacao.get(melhorIndice);
}

int[] cruzamentoOrdenado(int[] pai1, int[] pai2) {
  int n = pai1.length;
  int[] filho = new int[n];
  for (int i = 0; i < n; i++) filho[i] = -1;

  int inicio = int(random(n));
  int fim = int(random(n));
  if (inicio > fim) {
    int temp = inicio;
    inicio = fim;
    fim = temp;
  }

  boolean[] usado = new boolean[n];
  for (int i = inicio; i <= fim; i++) {
    filho[i] = pai1[i];
    usado[pai1[i]] = true;
  }

  int idxPai2 = (fim + 1) % n;
  int idxFilho = (fim + 1) % n;

  while (idxFilho != inicio) {
    int cidade = pai2[idxPai2];
    if (!usado[cidade]) {
      filho[idxFilho] = cidade;
      usado[cidade] = true;
      idxFilho = (idxFilho + 1) % n;
    }
    idxPai2 = (idxPai2 + 1) % n;
  }
  return filho;
}

void mutacaoTroca(int[] rota) {
  if (random(1) < taxaMutacao) {
    int i = int(random(rota.length));
    int j = int(random(rota.length));
    int temp = rota[i];
    rota[i] = rota[j];
    rota[j] = temp;
  }
}

void aplicarBuscaLocal2Opt() {
  if (melhorRotaGlobal == null || melhorRotaGlobal.length < 4) return;
  int n = melhorRotaGlobal.length;
  boolean melhorou = true;

  while (melhorou) {
    melhorou = false;
    for (int i = 0; i < n - 1; i++) {
      for (int j = i + 2; j < n; j++) {
        if (i == 0 && j == n - 1) continue;
        int a = melhorRotaGlobal[i];
        int b = melhorRotaGlobal[(i + 1) % n];
        int c = melhorRotaGlobal[j];
        int d = melhorRotaGlobal[(j + 1) % n];

        float atual = matrizDistancias[a][b] + matrizDistancias[c][d];
        float novo  = matrizDistancias[a][c] + matrizDistancias[b][d];

        if (novo < atual - 0.01) {
          inverterSegmento(melhorRotaGlobal, i + 1, j);
          melhorou = true;
        }
      }
    }
  }
  menorDistanciaGlobal = calcularDistanciaRota(melhorRotaGlobal);
  populacao.set(0, melhorRotaGlobal.clone());
  historicoDistancias.add(menorDistanciaGlobal);
}

void inverterSegmento(int[] rota, int inicio, int fim) {
  while (inicio < fim) {
    int temp = rota[inicio];
    rota[inicio] = rota[fim];
    rota[fim] = temp;
    inicio++;
    fim--;
  }
}

void embaralhar(int[] array) {
  for (int i = array.length - 1; i > 0; i--) {
    int j = int(random(i + 1));
    int temp = array[i];
    array[i] = array[j];
    array[j] = temp;
  }
}
