# La Quiete Mobile

Aplicativo multiplataforma do **La Quiete — Hotel, Ristorante e Bar**, desenvolvido em Flutter. A solução oferece uma experiência mobile para consultar o cardápio, acompanhar o programa de fidelidade e solicitar reservas.

## Funcionalidades

- Cadastro, login e recuperação de senha
- Cardápio com categorias, imagens, preços e alérgenos
- Pontuação e histórico do programa de fidelidade
- Solicitação e acompanhamento de reservas
- Tema e identidade visual fornecidos pelo backend
- Persistência de sessão no dispositivo
- Suporte a Android, iOS, Web, Windows, macOS e Linux
- Interface em italiano

## Tecnologias

- Flutter e Dart
- Provider para gerenciamento de estado
- HTTP para integração com a API REST
- Shared Preferences para persistência local
- Google Fonts
- Intl
- QR Flutter

## Como executar

### Pré-requisitos

- Flutter SDK 3.x
- Dart SDK compatível
- Um emulador, dispositivo físico ou navegador configurado
- Backend Flask compatível em execução

### Instalação

```bash
git clone <URL_DO_REPOSITORIO>
cd la_quiete_flutter
flutter pub get
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:5000
```

Em um emulador Android, o endereço do computador normalmente é `http://10.0.2.2:5000`. Em um dispositivo físico, use o IP local da máquina que executa o backend.

## Configuração

A configuração é fornecida em tempo de compilação:

```bash
flutter run \
  --dart-define=API_BASE_URL=https://api.exemplo.com \
  --dart-define=SYSTEM_USER=usuario \
  --dart-define=SYSTEM_PASS=senha
```

`SYSTEM_USER` e `SYSTEM_PASS` são opcionais e só devem ser usados se o backend legado exigir autenticação Basic. Aplicativos cliente podem ser inspecionados, portanto essas credenciais não devem ser tratadas como segredo. Em produção, prefira autenticação individual com tokens de curta duração e validação no servidor.

## Comandos úteis

```bash
flutter analyze       # executa a análise estática
flutter test          # executa os testes
flutter build apk     # gera o APK Android
flutter build appbundle  # gera o Android App Bundle
flutter build web     # gera a versão web
```

## Estrutura do projeto

```text
├── assets/           # ícones e recursos visuais
├── lib/
│   ├── config/       # configuração do ambiente
│   ├── models/       # modelos de dados
│   ├── pages/        # telas da aplicação
│   ├── providers/    # estado e sessão
│   ├── services/     # integração com a API
│   └── main.dart     # ponto de entrada
├── test/             # testes automatizados
├── android/          # projeto Android
├── ios/              # projeto iOS
└── web/              # projeto Web
```

## Integração com o backend

Este repositório contém somente o aplicativo cliente. As funcionalidades dependem de uma API REST com endpoints para autenticação, tema público, cardápio, fidelidade e reservas. Configure HTTPS, CORS e os mecanismos de autenticação no servidor antes de publicar.

## Licença

Projeto de portfólio. O código-fonte está disponível para consulta e demonstração; nenhum direito de uso comercial é concedido sem autorização do autor.
