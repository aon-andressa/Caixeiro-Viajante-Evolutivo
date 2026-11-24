void inicializarGrafo(int n) {
  cidades = new ArrayList<PVector>();
  for (int i = 0; i < n; i++) {
    float x = random(85, 695);
    float y = random(122, height - 85);
    cidades.add(new PVector(x, y));
  }
  atualizarMatrizDistancias();
}

void atualizarMatrizDistancias() {
  int n = cidades.size();
  matrizDistancias = new float[n][n];
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      matrizDistancias[i][j] = (i == j) ? 0 : PVector.dist(cidades.get(i), cidades.get(j));
    }
  }
}

float calcularDistanciaRota(int[] rota) {
  if (rota == null || rota.length < 2) return 0;
  float soma = 0;
  for (int i = 0; i < rota.length - 1; i++) {
    soma += matrizDistancias[rota[i]][rota[i + 1]];
  }
  soma += matrizDistancias[rota[rota.length - 1]][rota[0]];
  return soma;
}
