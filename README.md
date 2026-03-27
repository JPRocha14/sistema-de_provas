# 📱 Sistema de Prova Eletrônica

## 📌 Descrição do Projeto
O Sistema de Prova Eletrônica é uma aplicação mobile/web desenvolvida em Flutter com o objetivo de digitalizar a aplicação de avaliações acadêmicas. A solução permite que provas sejam realizadas diretamente em dispositivos digitais, substituindo completamente o uso de papel no processo avaliativo.

O projeto foi concebido como uma aplicação leve, multiplataforma e de fácil implementação em ambientes educacionais, especialmente dentro do contexto universitário.

---

## 🎯 Objetivo da Solução
A solução tem como principal propósito **reduzir o consumo de papel**, promovendo sustentabilidade dentro do ambiente acadêmico.

De forma estratégica, o sistema também busca:
- Modernizar o processo de avaliação
- Facilitar a aplicação de provas em larga escala
- Centralizar a experiência do aluno em um ambiente digital
- Reduzir custos operacionais com impressão
- Servir como base para expansão em outros ambientes educacionais

---

## 🏗️ Arquitetura Utilizada
A aplicação segue uma arquitetura **client-side**, baseada exclusivamente em Flutter, sem dependência de backend ou API externa.

Estrutura arquitetural:
- **Camada de Interface (UI):** Responsável pela renderização das telas e interação com o usuário
- **Camada de Lógica Local:** Gerencia estados, fluxo da aplicação e comportamento das provas diretamente no app
- **Execução Multiplataforma:** Suporte para Web, Android, iOS, Windows, Linux e macOS

Trata-se de uma arquitetura simplificada, ideal para protótipos funcionais e validação de conceito.

---

## 📁 Estrutura de Pastas

```
prova_eletronica_app/
│
├── lib/
│ └── main.dart # Arquivo principal da aplicação
│
├── web/ # Configurações para execução web
├── android/ # Configurações Android
├── ios/ # Configurações iOS
├── windows/ # Configurações Windows
├── macos/ # Configurações macOS
├── linux/ # Configurações Linux
│
├── test/ # Testes da aplicação
│
├── pubspec.yaml # Dependências do projeto
└── README.md
```
---

## 🛠️ Tecnologias Utilizadas
- **Flutter**
- **Dart**
- **HTML (estrutura web gerada pelo Flutter)**
- **Material Design (UI padrão do Flutter)**

A escolha do Flutter permite desenvolvimento único com deploy em múltiplas plataformas, reduzindo esforço de manutenção e aumentando escalabilidade futura.

---

## 🔄 Fluxo de Funcionamento da Aplicação

1. **Inicialização**
   - O aplicativo é iniciado através do arquivo `main.dart`.

2. **Renderização da Interface**
   - A interface é construída utilizando widgets do Flutter.

3. **Interação do Usuário**
   - O usuário navega pelas telas e interage com a prova diretamente no dispositivo.

4. **Execução Local**
   - Toda a lógica da aplicação ocorre localmente, sem dependência de servidores externos.

5. **Finalização**
   - O usuário conclui a prova dentro do próprio aplicativo.

---

## 🌱 Impacto Esperado
A adoção deste sistema representa uma mudança estrutural no modelo de avaliação tradicional, eliminando a dependência de papel e promovendo um ambiente educacional mais sustentável, tecnológico e eficiente.

A solução tem potencial direto de expansão, podendo evoluir para integrações mais robustas conforme a necessidade institucional.
