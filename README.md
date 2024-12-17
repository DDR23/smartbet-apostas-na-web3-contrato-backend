# smartbet-apostas-na-web3-contrato-backend

## Sobre o Projeto

O SmartbetDisputes é um sistema inovador de apostas descentralizadas implementado como um contrato inteligente na blockchain Ethereum. Este projeto foi desenvolvido para demonstrar as capacidades dos contratos inteligentes em criar um ambiente de apostas transparente, justo e automatizado.

### Detalhes Técnicos:

- **Rede**: Polygon Amoy Testnet
- **Endereço do Contrato**: 0x89674AA4a4d729605a4C6B1484d61401cC45341C
- **Hash da Transação**: 0xe2d5a52af17e65448040f9050e77f0c7914294df8186458ab601670ded3685ee
- **Bloco**: 13064581
- **Codigo fonte do contrato em**: [Polygon PoS Chain Amoy Testnet Explorer](https://amoy.polygonscan.com/address/0x89674AA4a4d729605a4C6B1484d61401cC45341C#code)
- **Repositório do DApp**: [atividade---DAPP---meu-primeiro-smartcontract---LUIZTOOLS](https://github.com/DDR23/atividade---DAPP---meu-primeiro-smartcontract---LUIZTOOLS)

### Principais Características:

1. **Descentralização**: Operando na blockchain Ethereum, o sistema elimina a necessidade de intermediários tradicionais, oferecendo uma plataforma de apostas verdadeiramente peer-to-peer.

2. **Transparência**: Todas as transações e lógica do contrato são públicas e verificáveis na blockchain, garantindo total transparência para os usuários.

3. **Automação**: O contrato inteligente gerencia automaticamente a criação de disputas, o processamento de apostas e a distribuição de prêmios, reduzindo erros humanos e aumentando a eficiência.

4. **Segurança**: Implementado em Solidity 0.8.26, o contrato incorpora as melhores práticas de segurança para proteger os fundos dos usuários e a integridade do sistema.

5. **Flexibilidade**: O sistema permite a criação de disputas com dois candidatos, adaptável a diversos cenários de apostas.

### Objetivos do Projeto:

1. Demonstrar a aplicação prática de contratos inteligentes em sistemas de apostas.
2. Oferecer uma alternativa descentralizada aos sistemas de apostas tradicionais.
3. Explorar os desafios e soluções na implementação de lógica de negócios complexa em contratos inteligentes.
4. Servir como um recurso educacional para desenvolvedores interessados em blockchain e Solidity.

Este projeto é um exemplo de como a tecnologia blockchain pode revolucionar indústrias tradicionais, oferecendo soluções mais transparentes, eficientes e acessíveis globalmente.

## Funcionalidades
- Criar disputas com dois candidatos
- Fazer apostas em candidatos
- Cálculo e coleta automática de taxas
- Distribuição justa de prêmios baseada nos valores das apostas
- Reivindicação de prêmios após a resolução da disputa

## Detalhes do Contrato Inteligente

### Componentes Principais
1. **Disputa**: Representa um evento de aposta com dois candidatos.
2. **Aposta**: Representa a aposta de um usuário em uma disputa específica.

### Funções Principais
- `createDispute`: Permite ao proprietário criar uma nova disputa.
- `createBet`: Permite aos usuários fazerem apostas em uma disputa.
- `finishDispute`: Permite ao proprietário resolver uma disputa declarando um vencedor.
- `claimPrize`: Permite aos vencedores reivindicarem seus prêmios.
- `toggleDisputeStatus`: Permite que o owner gerencie o status da disputa, para filtar quais disputas devem aparecer pro usuario.

### Estrutura de Taxas
- Uma taxa de 10% é deduzida de cada aposta.
- As taxas são coletadas pelo proprietário do contrato, no fechamento da disputa.

### Cálculo de Prêmios
- O contrato calcula o prêmio individual baseado na aposta e na aposta do candidato vencedor.

## Como Começar

### Pré-requisitos
- Solidity 0.8.26
- Ambiente de desenvolvimento Ethereum (ex: Remix, Truffle, Hardhat)
- Carteira Ethereum (ex: MetaMask)

### Implantação
1. Implante o contrato `SmartbetDisputes` na rede Ethereum de sua escolha.
2. O endereço que faz a implantação se torna o proprietário do contrato.

### Interagindo com o Contrato
- Use um frontend habilitado para web3 ou interaja diretamente através de interfaces de carteira Ethereum.

## Considerações de Segurança
- O contrato inclui controle de acesso para funções exclusivas do proprietário.

## Aviso Legal
Este contrato inteligente é fornecido como está e foi desencolvido apenas pra fins educacionais. Os usuários interagem com ele por sua própria conta e risco. Sempre realize a devida diligência antes de participar de qualquer sistema de apostas baseado em blockchain.
