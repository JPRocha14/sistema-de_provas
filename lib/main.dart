import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

enum TipoQuestao { multiplaEscolha, verdadeiroFalso, discursiva, estudoDeCaso, outro }

class Questao {
  String enunciado;
  TipoQuestao tipo;
  List<String> alternativas;
  int? respostaCorreta;
  String? respostaDiscursivaEsperada;
  double peso;
  dynamic respostaUsuario;
  double? notaAtribuida;

  Questao({
    required this.enunciado,
    required this.tipo,
    this.alternativas = const [],
    this.respostaCorreta,
    this.respostaDiscursivaEsperada,
    this.peso = 1.0,
    this.respostaUsuario,
    this.notaAtribuida,
  });

  void limpar() {
    respostaUsuario = null;
    notaAtribuida = null;
  }

  Questao clone() {
    return Questao(
      enunciado: enunciado,
      tipo: tipo,
      alternativas: List<String>.from(alternativas),
      respostaCorreta: respostaCorreta,
      respostaDiscursivaEsperada: respostaDiscursivaEsperada,
      peso: peso,
      respostaUsuario: respostaUsuario,
      notaAtribuida: notaAtribuida,
    );
  }
}

class Prova {
  String titulo;
  String turma;
  String disciplina;
  DateTime? inicio;
  DateTime? fim;
  List<Questao> questoes;
  bool disponivel;

  Prova({
    required this.titulo,
    required this.turma,
    required this.disciplina,
    required this.questoes,
    this.inicio,
    this.fim,
    this.disponivel = false,
  });

  void limparRespostas() {
    for (final q in questoes) {
      q.limpar();
    }
  }
}

class RespostaAluno {
  String nomeAluno;
  Prova prova;
  DateTime data;
  double pontuacao;

  RespostaAluno({
    required this.nomeAluno,
    required this.prova,
    required this.data,
    required this.pontuacao,
  });
}

List<Prova> provas = [];
List<String> turmas = ['1 SEMESTRE', '2 SEMESTRE', '12 SEMESTRE'];
List<String> disciplinas = ['BIG DATA', 'MACHINE LEARNING', 'GESTÃO DE PRODUTOS', 'GOVERNANÇA EM TI'];
List<RespostaAluno> respostasAluno = [];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prova Eletrônica',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: false,
      ),
      home: const TelaInicial(),
    );
  }
}

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const RodapeGlobal(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5A623), Color(0xFFFFE7CD)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            final isWide = constraints.maxWidth > 900;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Row(children: [
                Flexible(
                  flex: isWide ? 4 : 10,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 8,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.school, size: 48, color: Colors.black54),
                            const SizedBox(height: 18),
                            const Text('BEM-VINDO', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 18),
                            _largeRoleButton(context, 'SOU PROFESSOR', Icons.person, () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => TelaProfessor()));
                            }),
                            const SizedBox(height: 14),
                            _largeRoleButton(context, 'SOU ALUNO', Icons.person_outline, () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const TelaAluno()));
                            }),
                            const SizedBox(height: 12),
                            const Text('Prova Eletrônica • Uninassau', style: TextStyle(fontSize: 12, color: Colors.black54)),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ),
                if (isWide) const Spacer(),
                Flexible(
                  flex: isWide ? 6 : 0,
                  child: isWide
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 420,
                              child: Column(children: [
                                SizedBox(
                                  height: 250,
                                  child: Image.asset(
                                    'assets/logo.png',
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => const FlutterLogo(size: 120),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                const Text('UNINASSAU', style: TextStyle(fontSize: 56, fontWeight: FontWeight.w800, letterSpacing: 2)),
                              ]),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ]),
            );
          }),
        ),
      ),
    );
  }

  Widget _largeRoleButton(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 22),
        label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade200,
          foregroundColor: Colors.black87,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

class TelaProfessor extends StatefulWidget {
  TelaProfessor({super.key});

  @override
  State<TelaProfessor> createState() => _TelaProfessorState();
}

class _TelaProfessorState extends State<TelaProfessor> {
  final TextEditingController _searchController = TextEditingController();
  String filtro = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => filtro = _searchController.text.trim().toLowerCase());
    });
  }

  List<String> _disciplinasFiltradas() {
    if (filtro.isEmpty) return disciplinas;
    return disciplinas.where((d) => d.toLowerCase().contains(filtro)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final lista = _disciplinasFiltradas();

    return Scaffold(
      bottomNavigationBar: const RodapeGlobal(),
      appBar: AppBar(title: const Text('Área do Professor'), backgroundColor: const Color(0xFFDDB07A)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(builder: (context, constraints) {
          final isWide = constraints.maxWidth > 1000;
          return Row(children: [
            Expanded(
              flex: 5,
              child: ListView(children: [
                _searchField(),
                const SizedBox(height: 12),
                ...lista.map((d) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _disciplinaCard(context, d),
                    )),
                const SizedBox(height: 12),
                _addAssessmentCard(context),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const TelaGerenciarProvas())).then((_) => setState(() {}));
                  },
                  icon: const Icon(Icons.manage_accounts),
                  label: const Text('Gerenciar Todas as Provas'),
                ),
              ]),
            ),
            if (isWide)
              Expanded(
                flex: 5,
                child: Container(
                  margin: const EdgeInsets.only(left: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: const DecorationImage(
                      image: AssetImage('assets/student.jpg'),
                      alignment: Alignment.center,
                      fit: BoxFit.cover,
                    ),
                    color: Colors.grey.shade100,
                  ),
                ),
              ),
          ]);
        }),
      ),
    );
  }

  Widget _searchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: 'Pesquise pela Disciplina',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _disciplinaCard(BuildContext context, String disciplina) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(disciplina, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('PROFESSOR(A):', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
          const Text('Josenildo Oliveira de Almeida'),
          const SizedBox(height: 12),
          Row(children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.blue, elevation: 0),
              icon: const Icon(Icons.file_open),
              label: const Text('ACESSO A PROVA'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TelaGerenciarProvasDisciplina(disciplina: disciplina)),
                );
              },
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.bar_chart),
              label: const Text('RELATÓRIO'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TelaRelatorioProfessorDisciplina(disciplina: disciplina)),
                );
              },
            ),
          ]),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.rate_review),
            label: const Text('CORRIGIR DISCURSIVAS'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TelaCorrecaoManualDisciplina(disciplina: disciplina)),
              );
            },
          ),
        ]),
      ),
    );
  }

  Widget _addAssessmentCard(BuildContext context) {
    return Card(
      color: const Color(0xFFEFF6F7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.blue.shade200)),
      child: ListTile(
        leading: const Icon(Icons.add_box, size: 36),
        title: const Text('ADICIONAR AVALIAÇÃO', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text('Crie uma nova avaliação'),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const TelaCriarOuEditarProva()));
        },
      ),
    );
  }
}

class TelaGerenciarProvasDisciplina extends StatefulWidget {
  final String disciplina;
  const TelaGerenciarProvasDisciplina({super.key, required this.disciplina});

  @override
  State<TelaGerenciarProvasDisciplina> createState() => _TelaGerenciarProvasDisciplinaState();
}

class _TelaGerenciarProvasDisciplinaState extends State<TelaGerenciarProvasDisciplina> {
  @override
  Widget build(BuildContext context) {
    final lista = provas.where((p) => p.disciplina == widget.disciplina).toList();

    return Scaffold(
      bottomNavigationBar: const RodapeGlobal(),
      appBar: AppBar(title: Text('Gerenciar Provas • ${widget.disciplina}')),
      body: lista.isEmpty
          ? const Center(child: Text('Nenhuma prova cadastrada nesta disciplina'))
          : ListView.builder(
              itemCount: lista.length,
              itemBuilder: (_, i) {
                final p = lista[i];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  child: ListTile(
                    title: Text(p.titulo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text('${p.turma} • ${p.questoes.length} questões'),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => TelaVisualizarProvaProfessor(prova: p)));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => TelaCriarOuEditarProva(editarProva: p))).then((_) => setState(() {}));
                        },
                      ),
                      IconButton(
                        icon: Icon(p.disponivel ? Icons.toggle_on : Icons.toggle_off, size: 32, color: p.disponivel ? Colors.green : Colors.grey),
                        onPressed: () {
                          setState(() => p.disponivel = !p.disponivel);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirmar = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Excluir Prova'),
                                  content: Text('Deseja realmente excluir "${p.titulo}"?\nTodas as respostas desta prova serão apagadas.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                                    ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir')),
                                  ],
                                ),
                              ) ??
                              false;

                          if (confirmar) {
                            setState(() {
                              respostasAluno.removeWhere((x) => x.prova == p);
                              provas.remove(p);
                            });

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Prova "${p.titulo}" removida com sucesso.')));
                          }
                        },
                      ),
                    ]),
                  ),
                );
              },
            ),
    );
  }
}

class TelaGerenciarProvas extends StatefulWidget {
  const TelaGerenciarProvas({super.key});

  @override
  State<TelaGerenciarProvas> createState() => _TelaGerenciarProvasState();
}

class _TelaGerenciarProvasState extends State<TelaGerenciarProvas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const RodapeGlobal(),
      appBar: AppBar(title: const Text('Gerenciar Provas')),
      body: provas.isEmpty
          ? const Center(child: Text('Nenhuma prova cadastrada'))
          : ListView.builder(
              itemCount: provas.length,
              itemBuilder: (_, i) {
                final p = provas[i];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  child: ListTile(
                    title: Text(p.titulo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text('${p.turma} • ${p.disciplina} • ${p.questoes.length} questões'),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => TelaVisualizarProvaProfessor(prova: p)));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => TelaCriarOuEditarProva(editarProva: p))).then((_) => setState(() {}));
                        },
                      ),
                      IconButton(
                        icon: Icon(p.disponivel ? Icons.toggle_on : Icons.toggle_off, size: 32, color: p.disponivel ? Colors.green : Colors.grey),
                        onPressed: () {
                          setState(() => p.disponivel = !p.disponivel);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirmar = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Confirmar exclusão'),
                                  content: Text('Deseja excluir a prova "${p.titulo}" da turma ${p.turma}?\n\nTodas as respostas associadas também serão apagadas.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                                    ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir')),
                                  ],
                                ),
                              ) ??
                              false;

                          if (confirmar) {
                            setState(() {
                              respostasAluno.removeWhere((r) => r.prova == p);
                              provas.removeAt(i);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Prova "${p.titulo}" removida.')));
                          }
                        },
                      ),
                    ]),
                  ),
                );
              },
            ),
    );
  }
}

class TelaRelatorioProfessorDisciplina extends StatelessWidget {
  final String disciplina;
  const TelaRelatorioProfessorDisciplina({super.key, required this.disciplina});

  @override
  Widget build(BuildContext context) {
    final respostas = respostasAluno.where((r) => r.prova.disciplina == disciplina).toList();
    final Map<String, List<RespostaAluno>> porProva = {};
    for (final r in respostas) {
      porProva.putIfAbsent(r.prova.titulo, () => []).add(r);
    }

    return Scaffold(
      bottomNavigationBar: const RodapeGlobal(),
      appBar: AppBar(title: Text('Relatórios • $disciplina')),
      body: porProva.isEmpty
          ? const Center(child: Text('Nenhuma resposta para esta disciplina'))
          : ListView(
              padding: const EdgeInsets.all(12),
              children: porProva.entries.map((entry) {
                final provaTitulo = entry.key;
                final respostasDaProva = entry.value;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(provaTitulo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...respostasDaProva.map((r) => ListTile(
                            title: Text(r.nomeAluno),
                            subtitle: Text('Turma: ${r.prova.turma} • Data: ${r.data.toLocal().toString().split(" ")[0]}'),
                            trailing: Text('${r.pontuacao}/10'),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => TelaVisualizarProvaAluno(prova: r.prova, somenteLeitura: true)));
                            },
                          )),
                    ]),
                  ),
                );
              }).toList(),
            ),
    );
  }
}

class TelaCorrecaoManualDisciplina extends StatefulWidget {
  final String disciplina;
  const TelaCorrecaoManualDisciplina({super.key, required this.disciplina});

  @override
  State<TelaCorrecaoManualDisciplina> createState() => _TelaCorrecaoManualDisciplinaState();
}

class _TelaCorrecaoManualDisciplinaState extends State<TelaCorrecaoManualDisciplina> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> itens = [];
    for (final p in provas.where((p) => p.disciplina == widget.disciplina)) {
      for (final q in p.questoes) {
        final eDisc = q.tipo == TipoQuestao.discursiva || q.tipo == TipoQuestao.estudoDeCaso;
        if (eDisc && q.respostaUsuario != null) {
          itens.add({'prova': p, 'questao': q});
        }
      }
    }

    final Map<String, List<Map<String, dynamic>>> porProva = {};
    for (final item in itens) {
      final provaTitulo = (item['prova'] as Prova).titulo;
      porProva.putIfAbsent(provaTitulo, () => []).add(item);
    }

    return Scaffold(
      bottomNavigationBar: const RodapeGlobal(),
      appBar: AppBar(title: Text('Corrigir • ${widget.disciplina}')),
      body: porProva.isEmpty
          ? const Center(child: Text('Nenhuma questão discursiva respondida'))
          : ListView(
              padding: const EdgeInsets.all(12),
              children: porProva.entries.map((entry) {
                final provaTitulo = entry.key;
                final lista = entry.value;
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(provaTitulo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...lista.map((item) {
                    final p = item['prova'] as Prova;
                    final q = item['questao'] as Questao;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('${p.titulo} • ${p.turma}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text('Q: ${q.enunciado}', style: const TextStyle(fontSize: 15)),
                          const SizedBox(height: 12),
                          const Text('Resposta do aluno:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text((q.respostaUsuario ?? '-').toString(), maxLines: 8),
                          const SizedBox(height: 12),
                          const Text('Resposta esperada (professor):', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(q.respostaDiscursivaEsperada ?? '-', maxLines: 8),
                          const SizedBox(height: 16),
                          Row(children: [
                            const Text('Nota:'),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 120,
                              child: TextFormField(
                                initialValue: q.notaAtribuida?.toStringAsFixed(2) ?? '',
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: InputDecoration(hintText: '0 – ${q.peso.toStringAsFixed(2)}'),
                                onChanged: (v) {
                                  final val = double.tryParse(v.replaceAll(',', '.'));
                                  if (val == null) return;
                                  if (val < 0 || val > q.peso) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('A nota deve estar entre 0 e ${q.peso}')));
                                    return;
                                  }
                                  setState(() => q.notaAtribuida = val);
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('/ ${q.peso} pts'),
                          ]),
                        ]),
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                ]);
              }).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          _recalcularNotasDisciplina(widget.disciplina);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notas salvas e pontuações atualizadas')));
        },
      ),
    );
  }

  void _recalcularNotasDisciplina(String disc) {
    for (final r in respostasAluno.where((x) => x.prova.disciplina == disc)) {
      double total = 0;
      for (final q in r.prova.questoes) {
        if (q.tipo == TipoQuestao.multiplaEscolha || q.tipo == TipoQuestao.verdadeiroFalso) {
          if (q.respostaUsuario != null && q.respostaCorreta != null && q.respostaUsuario == q.respostaCorreta) total += q.peso;
        } else {
          if (q.notaAtribuida != null) total += q.notaAtribuida!;
        }
      }
      r.pontuacao = double.parse(total.toStringAsFixed(2));
    }
  }
}

class TelaAluno extends StatefulWidget {
  const TelaAluno({super.key});

  @override
  State<TelaAluno> createState() => _TelaAlunoState();
}

class _TelaAlunoState extends State<TelaAluno> {
  final TextEditingController _searchControllerAluno = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchControllerAluno.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final textoFiltro = _searchControllerAluno.text.trim().toLowerCase();

    final disponiveis = provas.where((p) => p.disponivel && !respostasAluno.any((r) => r.prova == p) && p.titulo.toLowerCase().contains(textoFiltro)).toList();

    final Map<String, List<Prova>> disponiveisPorDisciplina = {};
    for (final p in disponiveis) {
      disponiveisPorDisciplina.putIfAbsent(p.disciplina, () => []).add(p);
    }

    final historico = respostasAluno.where((r) => r.prova.titulo.toLowerCase().contains(textoFiltro)).toList();

    return Scaffold(
      bottomNavigationBar: const RodapeGlobal(),
      appBar: AppBar(title: const Text('Disciplinas (Aluno)'), backgroundColor: const Color(0xFFDDB07A)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(builder: (context, constraints) {
          final isWide = constraints.maxWidth > 1000;
          return Row(children: [
            Expanded(
              flex: 6,
              child: ListView(children: [
                _searchFieldAluno(),
                const SizedBox(height: 12),
                if (disponiveisPorDisciplina.isNotEmpty)
                  ...disponiveisPorDisciplina.entries.map((entry) {
                    final disc = entry.key;
                    final provasDaDisc = entry.value;
                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(disc, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...provasDaDisc.map((p) => _disciplinaCardAluno(context, p)),
                      const SizedBox(height: 14),
                    ]);
                  })
                else
                  const Text('Nenhuma prova disponível', style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 20),
                if (historico.isNotEmpty) const Text('Histórico', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ...historico.map((r) => Card(
                      child: ListTile(
                        title: Text(r.prova.titulo, style: const TextStyle(fontSize: 16)),
                        subtitle: Text('Turma: ${r.prova.turma} • Disciplina: ${r.prova.disciplina}'),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(6)),
                          child: Text('${r.pontuacao.toStringAsFixed(1)}/10', style: const TextStyle(color: Colors.white)),
                        ),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TelaVisualizarProvaAluno(prova: r.prova, somenteLeitura: true))),
                      ),
                    )),
              ]),
            ),
            if (isWide)
              Expanded(
                flex: 4,
                child: Container(
                  margin: const EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
                  ),
                  child: Column(children: [
                    Expanded(
                      child: Center(
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/aluno.webp'),
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text('Boa prova! Responda com calma', style: TextStyle(color: Colors.grey.shade700)),
                    ),
                  ]),
                ),
              ),
          ]);
        }),
      ),
    );
  }

  Widget _searchFieldAluno() {
    return TextField(
      controller: _searchControllerAluno,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: 'Pesquisar pelo nome da prova...',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _disciplinaCardAluno(BuildContext context, Prova p) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('PRESENCIAL', style: TextStyle(fontSize: 12, color: Colors.black54)),
              const SizedBox(height: 6),
              Text(p.titulo, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Disciplina: ${p.disciplina}', style: const TextStyle(color: Colors.black54)),
            ]),
            const Spacer(),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Colors.grey.shade200),
              child: const Center(child: Text('--\nNOTA', textAlign: TextAlign.center)),
            )
          ]),
          const Divider(height: 18),
          Row(children: [
            Expanded(child: TextButton.icon(onPressed: () => _abrirProva(context, p), icon: const Icon(Icons.assignment), label: const Text('ACESSO A PROVA'))),
          ])
        ]),
      ),
    );
  }

  Future<void> _abrirProva(BuildContext context, Prova prova) async {
    final nomeController = TextEditingController();
    final iniciou = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Instruções'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Esta prova só pode ser feita uma vez.\nDigite seu nome completo para iniciar:'),
                TextField(controller: nomeController, decoration: const InputDecoration(labelText: 'Nome completo')),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
              ElevatedButton(
                onPressed: () {
                  if (nomeController.text.trim().isEmpty) return;
                  Navigator.pop(context, true);
                },
                child: const Text('Iniciar'),
              ),
            ],
          ),
        ) ??
        false;

    if (iniciou) {
      final pontuacao = await Navigator.push<double>(
        context,
        MaterialPageRoute(builder: (_) => TelaResponderProvaComNome(prova: prova, nomeAluno: nomeController.text.trim())),
      );

      if (pontuacao != null) {
        setState(() {
          respostasAluno.add(RespostaAluno(nomeAluno: nomeController.text.trim(), prova: prova, data: DateTime.now(), pontuacao: pontuacao));
        });
      }
    }
  }
}

class TelaCriarOuEditarProva extends StatefulWidget {
  final Prova? editarProva;
  const TelaCriarOuEditarProva({super.key, this.editarProva});

  @override
  State<TelaCriarOuEditarProva> createState() => _TelaCriarOuEditarProvaState();
}

class _TelaCriarOuEditarProvaState extends State<TelaCriarOuEditarProva> {
  final tituloController = TextEditingController();
  List<String> turmasSelecionadas = [turmas.first];
  String disciplinaSelecionada = disciplinas.first;
  List<Questao> questoes = [];

  @override
  void initState() {
    super.initState();
    if (widget.editarProva != null) {
      final p = widget.editarProva!;
      tituloController.text = p.titulo;
      turmasSelecionadas = [p.turma];
      disciplinaSelecionada = p.disciplina;
      questoes = p.questoes.map((q) => q.clone()).toList();
    }
  }

  void adicionarQuestao(TipoQuestao tipo) {
    setState(() {
      questoes.add(
        Questao(
          enunciado: '',
          tipo: tipo,
          alternativas: tipo == TipoQuestao.multiplaEscolha ? List.generate(4, (_) => '') : [],
          respostaCorreta: tipo == TipoQuestao.multiplaEscolha ? 0 : (tipo == TipoQuestao.verdadeiroFalso ? 0 : null),
          peso: 1.0,
        ),
      );
    });
  }

  Future<void> _selecionarTurmasDialog() async {
    final selecionadasTemp = Set<String>.from(turmasSelecionadas);
    await showDialog<void>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Selecionar Turmas'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: turmas.map((t) {
                  return CheckboxListTile(
                    value: selecionadasTemp.contains(t),
                    title: Text(t),
                    activeColor: Colors.deepOrange,
                    onChanged: (v) {
                      setStateDialog(() {
                        if (v == true) {
                          selecionadasTemp.add(t);
                        } else {
                          selecionadasTemp.remove(t);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
              ElevatedButton(
                onPressed: () {
                  if (selecionadasTemp.isNotEmpty) {
                    setState(() {
                      turmasSelecionadas = selecionadasTemp.toList();
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('OK'),
              )
            ],
          );
        },
      ),
    );
  }

  void normalizarPesos() {
    final total = questoes.fold<double>(0, (s, q) => s + q.peso);
    if (total <= 0) return;
    final fator = 10 / total;
    for (final q in questoes) {
      q.peso = double.parse((q.peso * fator).toStringAsFixed(2));
    }
    final soma = questoes.fold<double>(0, (s, q) => s + q.peso);
    if (questoes.isNotEmpty && soma != 10) {
      final diff = 10 - soma;
      questoes.last.peso = double.parse((questoes.last.peso + diff).toStringAsFixed(2));
    }
  }

  void salvar() {
    if (tituloController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Título obrigatório')));
      return;
    }
    if (questoes.any((q) => q.enunciado.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Todas as questões precisam de enunciado')));
      return;
    }
    if (turmasSelecionadas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecione ao menos uma turma')));
      return;
    }

    normalizarPesos();

    for (final turma in turmasSelecionadas) {
      final p = Prova(
        titulo: tituloController.text.trim(),
        turma: turma,
        disciplina: disciplinaSelecionada,
        questoes: questoes.map((q) => q.clone()).toList(),
        disponivel: true,
      );

      if (widget.editarProva != null) {
        final idx = provas.indexWhere((x) => x == widget.editarProva);
        if (idx >= 0) {
          provas[idx] = p;
        } else {
          provas.add(p);
        }
      } else {
        provas.add(p);
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Prova(s) salva(s) e disponibilizada(s)')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const RodapeGlobal(),
      appBar: AppBar(title: Text(widget.editarProva != null ? 'Editar Prova' : 'Criar Prova')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: tituloController, decoration: const InputDecoration(labelText: 'Título da prova')),
          const SizedBox(height: 10),
          TextButton(onPressed: _selecionarTurmasDialog, child: Text('Turmas: ${turmasSelecionadas.join(', ')}')),
          DropdownButton<String>(
            value: disciplinaSelecionada,
            items: disciplinas.map((d) => DropdownMenuItem(value: d, child: Text('Disciplina: $d'))).toList(),
            onChanged: (v) => setState(() => disciplinaSelecionada = v!),
          ),
          const SizedBox(height: 12),
          Wrap(spacing: 8, children: [
            ElevatedButton(onPressed: () => adicionarQuestao(TipoQuestao.multiplaEscolha), child: const Text('Adicionar Múltipla')),
            ElevatedButton(onPressed: () => adicionarQuestao(TipoQuestao.verdadeiroFalso), child: const Text('Adicionar V/F')),
            ElevatedButton(onPressed: () => adicionarQuestao(TipoQuestao.discursiva), child: const Text('Adicionar Discursiva')),
          ]),
          const SizedBox(height: 16),
          ...questoes.asMap().entries.map((e) => cardQuestao(e.key, e.value)),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: salvar, child: const Text('Salvar e Disponibilizar (normaliza pesos para 10 pontos)')),
        ],
      ),
    );
  }

  Widget cardQuestao(int index, Questao q) {
    final enunciadoController = TextEditingController(text: q.enunciado);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Questão ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
          TextField(controller: enunciadoController, decoration: const InputDecoration(labelText: 'Enunciado'), onChanged: (v) => q.enunciado = v),
          const SizedBox(height: 8),
          Row(children: [
            const Text('Tipo: '),
            DropdownButton<TipoQuestao>(
              value: q.tipo,
              items: TipoQuestao.values.map((t) => DropdownMenuItem(value: t, child: Text(t.toString().split('.').last))).toList(),
              onChanged: (v) => setState(() => q.tipo = v!),
            ),
            const SizedBox(width: 20),
            const Text('Peso:'),
            const SizedBox(width: 8),
            SizedBox(
              width: 80,
              child: TextFormField(
                initialValue: q.peso.toStringAsFixed(2),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (v) {
                  final val = double.tryParse(v.replaceAll(',', '.'));
                  if (val != null) setState(() => q.peso = val);
                },
              ),
            ),
            const SizedBox(width: 8),
            const Text('pts'),
          ]),
          const SizedBox(height: 8),
          if (q.tipo == TipoQuestao.multiplaEscolha) ...[
            const Text('Alternativas (marque a correta)'),
            ...List.generate(q.alternativas.length, (i) => Row(children: [
                  Radio<int>(value: i, groupValue: q.respostaCorreta ?? 0, onChanged: (val) => setState(() => q.respostaCorreta = val)),
                  Expanded(child: TextFormField(initialValue: q.alternativas[i], decoration: InputDecoration(labelText: 'Alternativa ${String.fromCharCode(65 + i)}'), onChanged: (v) => q.alternativas[i] = v)),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      if (q.alternativas.length <= 2) return;
                      setState(() {
                        q.alternativas = List<String>.from(q.alternativas);
                        final removedIndex = i;
                        q.alternativas.removeAt(removedIndex);
                        if (q.respostaCorreta != null) {
                          if (q.respostaCorreta == removedIndex) {
                            q.respostaCorreta = null;
                          } else if (q.respostaCorreta! > removedIndex) {
                            q.respostaCorreta = q.respostaCorreta! - 1;
                          }
                        }
                      });
                    },
                  ),
                ])),
            Row(children: [TextButton(onPressed: () {
              setState(() {
                q.alternativas = List<String>.from(q.alternativas);
                q.alternativas.add('');
              });
            }, child: const Text('Adicionar alternativa'))]),
          ],
          if (q.tipo == TipoQuestao.verdadeiroFalso) ...[
            const SizedBox(height: 6),
            const Text('Selecione a resposta correta:'),
            DropdownButton<int>(
              value: q.respostaCorreta ?? 0,
              items: const [
                DropdownMenuItem(value: 0, child: Text('Verdadeiro')),
                DropdownMenuItem(value: 1, child: Text('Falso')),
              ],
              onChanged: (v) => setState(() => q.respostaCorreta = v),
            ),
          ],
          if (q.tipo == TipoQuestao.discursiva || q.tipo == TipoQuestao.estudoDeCaso) ...[
            const SizedBox(height: 6),
            TextFormField(initialValue: q.respostaDiscursivaEsperada ?? '', decoration: const InputDecoration(labelText: 'Resposta esperada (opcional)'), maxLines: 3, onChanged: (v) => q.respostaDiscursivaEsperada = v),
          ],
          const SizedBox(height: 8),
          ElevatedButton(onPressed: () => setState(() => questoes.removeAt(index)), child: const Text('Remover Questão')),
        ]),
      ),
    );
  }
}

class TelaVisualizarProvaProfessor extends StatelessWidget {
  final Prova prova;
  const TelaVisualizarProvaProfessor({super.key, required this.prova});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const RodapeGlobal(),
      appBar: AppBar(title: const Text('Visualizar Prova (Professor)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(prova.titulo, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text('Turma: ${prova.turma} • Disciplina: ${prova.disciplina}'),
          const SizedBox(height: 12),
          ...prova.questoes.asMap().entries.map((e) => Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Q${e.key + 1} (${e.value.peso} pts) - ${e.value.tipo.toString().split('.').last}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(e.value.enunciado),
                    const SizedBox(height: 6),
                    if (e.value.tipo == TipoQuestao.multiplaEscolha)
                      ...e.value.alternativas.asMap().entries.map((alt) => Row(children: [Radio<int>(value: alt.key, groupValue: e.value.respostaCorreta ?? 0, onChanged: null), Expanded(child: Text('${String.fromCharCode(65 + alt.key)}. ${alt.value}'))])),
                    if (e.value.tipo == TipoQuestao.verdadeiroFalso) Text('Resposta correta: ${e.value.respostaCorreta == 0 ? 'Verdadeiro' : 'Falso'}'),
                    if (e.value.tipo == TipoQuestao.discursiva || e.value.tipo == TipoQuestao.estudoDeCaso) Text('Resposta esperada (opcional): ${e.value.respostaDiscursivaEsperada ?? '-'}'),
                  ]),
                ),
              )),
        ],
      ),
    );
  }
}

class TelaResponderProvaComNome extends StatefulWidget {
  final Prova prova;
  final String nomeAluno;
  const TelaResponderProvaComNome({super.key, required this.prova, required this.nomeAluno});

  @override
  State<TelaResponderProvaComNome> createState() => _TelaResponderProvaComNomeState();
}

class _TelaResponderProvaComNomeState extends State<TelaResponderProvaComNome> {
  double calcularPontuacao() {
    double total = 0;
    for (final q in widget.prova.questoes) {
      if (q.tipo == TipoQuestao.multiplaEscolha || q.tipo == TipoQuestao.verdadeiroFalso) {
        if (q.respostaUsuario != null && q.respostaCorreta != null && q.respostaUsuario == q.respostaCorreta) total += q.peso;
      } else {
        if (q.notaAtribuida != null) total += q.notaAtribuida!;
      }
    }
    return double.parse(total.toStringAsFixed(2));
  }

  Future<void> confirmarFinalizacao() async {
    final confirmar = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Confirmar envio'),
            content: const Text('Tem certeza que deseja entregar a prova?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
              ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Enviar')),
            ],
          ),
        ) ??
        false;
    if (confirmar) {
      final pontuacao = calcularPontuacao();
      Navigator.pop(context, pontuacao);
    }
  }

  Future<bool> _onWillPop() async {
    await confirmarFinalizacao();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(title: Text('${widget.prova.titulo} - ${widget.nomeAluno}')),
        body: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            ...widget.prova.questoes.asMap().entries.map((e) {
              final q = e.value;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Q${e.key + 1} (${q.peso} pts)', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(q.enunciado),
                    const SizedBox(height: 8),
                    if (q.tipo == TipoQuestao.multiplaEscolha) ...q.alternativas.asMap().entries.map((alt) => RadioListTile<int>(title: Text('${String.fromCharCode(65 + alt.key)}. ${alt.value}'), value: alt.key, groupValue: q.respostaUsuario, onChanged: (v) => setState(() => q.respostaUsuario = v))).toList(),
                    if (q.tipo == TipoQuestao.verdadeiroFalso)
                      Column(children: [
                        RadioListTile<int>(title: const Text('Verdadeiro'), value: 0, groupValue: q.respostaUsuario, onChanged: (v) => setState(() => q.respostaUsuario = v)),
                        RadioListTile<int>(title: const Text('Falso'), value: 1, groupValue: q.respostaUsuario, onChanged: (v) => setState(() => q.respostaUsuario = v)),
                      ]),
                    if (q.tipo == TipoQuestao.discursiva || q.tipo == TipoQuestao.estudoDeCaso)
                      TextField(maxLines: 5, decoration: InputDecoration(labelText: 'Resposta (valor máximo: ${q.peso} pts)'), onChanged: (v) => setState(() => q.respostaUsuario = v)),
                  ]),
                ),
              );
            }),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: confirmarFinalizacao, child: const Text('Finalizar Prova')),
          ],
        ),
      ),
    );
  }
}

class TelaResultadoAluno extends StatelessWidget {
  final Prova prova;
  const TelaResultadoAluno({super.key, required this.prova});

  double calcularPontuacao() {
    double total = 0;
    for (final q in prova.questoes) {
      if (q.tipo == TipoQuestao.multiplaEscolha || q.tipo == TipoQuestao.verdadeiroFalso) {
        if (q.respostaUsuario != null && q.respostaCorreta != null && q.respostaUsuario == q.respostaCorreta) total += q.peso;
      } else {
        if (q.notaAtribuida != null) total += q.notaAtribuida!;
      }
    }
    return double.parse(total.toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    final pontuacao = calcularPontuacao();
    return Scaffold(
      bottomNavigationBar: const RodapeGlobal(),
      appBar: AppBar(title: const Text('Resultado (feedback)')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          Text('Pontuação obtida: $pontuacao / 10', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: prova.questoes.length,
              itemBuilder: (_, i) {
                final q = prova.questoes[i];
                final objetivo = q.tipo == TipoQuestao.multiplaEscolha || q.tipo == TipoQuestao.verdadeiroFalso;
                final acertou = q.respostaUsuario != null && q.respostaCorreta != null && q.respostaUsuario == q.respostaCorreta;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Q${i + 1}: ${q.enunciado}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      if (objetivo)
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Sua resposta: ${_textoResposta(q)}'),
                          Text('Resposta correta: ${_textoRespostaCorreta(q)}'),
                          const SizedBox(height: 6),
                          Row(children: [
                            Icon(acertou ? Icons.check_circle : Icons.cancel, color: acertou ? Colors.green : Colors.red),
                            const SizedBox(width: 8),
                            Text(acertou ? 'Correto' : 'Incorreto'),
                            const SizedBox(width: 12),
                            Text('Valor: ${q.peso} pts'),
                          ]),
                        ])
                      else
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('Sua resposta:'),
                          Text((q.respostaUsuario ?? '-').toString(), maxLines: 8),
                          const SizedBox(height: 6),
                          Text('Nota atribuída: ${q.notaAtribuida != null ? q.notaAtribuida!.toStringAsFixed(2) : 'Pendente (correção manual)'}'),
                          const SizedBox(height: 6),
                          Text('Peso total da questão: ${q.peso} pts'),
                        ]),
                    ]),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(onPressed: () => Navigator.popUntil(context, (r) => r.isFirst), child: const Text('Voltar ao Início')),
        ]),
      ),
    );
  }

  String _textoResposta(Questao q) {
    if (q.tipo == TipoQuestao.multiplaEscolha) return q.respostaUsuario != null ? String.fromCharCode(65 + (q.respostaUsuario as int)) : '-';
    if (q.tipo == TipoQuestao.verdadeiroFalso) {
      if (q.respostaUsuario == null) return '-';
      return q.respostaUsuario == 0 ? 'Verdadeiro' : 'Falso';
    }
    return q.respostaUsuario?.toString() ?? '-';
  }

  String _textoRespostaCorreta(Questao q) {
    if (q.tipo == TipoQuestao.multiplaEscolha) return q.respostaCorreta != null ? String.fromCharCode(65 + q.respostaCorreta!) : '-';
    if (q.tipo == TipoQuestao.verdadeiroFalso) return q.respostaCorreta == 0 ? 'Verdadeiro' : 'Falso';
    return q.respostaDiscursivaEsperada ?? '-';
  }
}

class TelaVisualizarProvaAluno extends StatelessWidget {
  final Prova prova;
  final bool somenteLeitura;
  const TelaVisualizarProvaAluno({super.key, required this.prova, this.somenteLeitura = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const RodapeGlobal(),
      appBar: AppBar(title: const Text('Visualizar Prova (Aluno)')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: prova.questoes.asMap().entries.map((e) {
          final q = e.value;
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Q${e.key + 1} (${q.peso} pts)', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(q.enunciado),
                const SizedBox(height: 8),
                if (q.tipo == TipoQuestao.multiplaEscolha) ...q.alternativas.asMap().entries.map((alt) => Row(children: [Radio<int>(value: alt.key, groupValue: q.respostaUsuario, onChanged: null), Expanded(child: Text('${String.fromCharCode(65 + alt.key)}. ${alt.value}'))])),
                if (q.tipo == TipoQuestao.verdadeiroFalso) Text('Resposta: ${q.respostaUsuario == null ? '-' : (q.respostaUsuario == 0 ? 'Verdadeiro' : 'Falso')}'),
                if (q.tipo == TipoQuestao.discursiva || q.tipo == TipoQuestao.estudoDeCaso)
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Sua resposta:'),
                    const SizedBox(height: 6),
                    Text((q.respostaUsuario ?? '-').toString(), maxLines: 8),
                  ]),
              ]),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class TelaCorrecaoManual extends StatefulWidget {
  const TelaCorrecaoManual({super.key});

  @override
  State<TelaCorrecaoManual> createState() => _TelaCorrecaoManualState();
}

class _TelaCorrecaoManualState extends State<TelaCorrecaoManual> {
  @override
  Widget build(BuildContext context) {
    final lista = <Map<String, dynamic>>[];
    for (final p in provas) {
      for (final q in p.questoes) {
        if ((q.tipo == TipoQuestao.discursiva || q.tipo == TipoQuestao.estudoDeCaso) && q.respostaUsuario != null) {
          lista.add({'prova': p, 'questao': q});
        }
      }
    }

    final Map<String, List<Map<String, dynamic>>> porProva = {};
    for (final item in lista) {
      final provaTitulo = (item['prova'] as Prova).titulo;
      porProva.putIfAbsent(provaTitulo, () => []).add(item);
    }

    return Scaffold(
      bottomNavigationBar: const RodapeGlobal(),
      appBar: AppBar(title: const Text('Correção manual (discursivas)')),
      body: porProva.isEmpty
          ? const Center(child: Text('Não há respostas discursivas para corrigir (simulação)'))
          : ListView(
              padding: const EdgeInsets.all(12),
              children: porProva.entries.map((entry) {
                final provaTitulo = entry.key;
                final items = entry.value;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(provaTitulo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...items.map((map) {
                        final p = map['prova'] as Prova;
                        final q = map['questao'] as Questao;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('${p.titulo} • ${p.turma} • ${p.disciplina}'),
                            const SizedBox(height: 6),
                            Text('Q: ${q.enunciado}'),
                            const SizedBox(height: 6),
                            const Text('Resposta do aluno:'),
                            Text((q.respostaUsuario ?? '-').toString(), maxLines: 8),
                            const SizedBox(height: 6),
                            const Text('Resposta esperada (professor):'),
                            Text(q.respostaDiscursivaEsperada ?? '-', maxLines: 8),
                            const SizedBox(height: 8),
                            Row(children: [
                              const Text('Nota:'),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 120,
                                child: TextFormField(
                                  initialValue: q.notaAtribuida?.toStringAsFixed(2) ?? '',
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: InputDecoration(hintText: '0 – ${q.peso.toStringAsFixed(2)}'),
                                  onChanged: (v) {
                                    final val = double.tryParse(v.replaceAll(',', '.'));
                                    if (val == null) return;
                                    if (val < 0 || val > q.peso) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('A nota deve estar entre 0 e ${q.peso}')));
                                      return;
                                    }
                                    setState(() => q.notaAtribuida = val);
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text('/ ${q.peso} pts'),
                            ]),
                            const Divider(height: 20),
                          ]),
                        );
                      }),
                    ]),
                  ),
                );
              }).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          _recalcularTodasNotas();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notas salvas e pontuações atualizadas')));
        },
      ),
    );
  }

  void _recalcularTodasNotas() {
    for (final r in respostasAluno) {
      double total = 0;
      for (final q in r.prova.questoes) {
        if (q.tipo == TipoQuestao.multiplaEscolha || q.tipo == TipoQuestao.verdadeiroFalso) {
          if (q.respostaUsuario != null && q.respostaCorreta != null && q.respostaUsuario == q.respostaCorreta) total += q.peso;
        } else {
          if (q.notaAtribuida != null) total += q.notaAtribuida!;
        }
      }
      r.pontuacao = double.parse(total.toStringAsFixed(2));
    }
  }
}

class RodapeGlobal extends StatelessWidget {
  const RodapeGlobal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      color: Colors.black87,
      alignment: Alignment.center,
      child: const Text('Prova Eletrônica • Uninassau', style: TextStyle(color: Colors.white, fontSize: 11)),
    );
  }
}
