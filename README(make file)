		Ambiente
============================================

Para rodar o projeto, precisa-se baixar o qemu
e o nasm, no ubuntu, execute esse comando no terminal,

	sudo apt-get install qemu nasm




		Tutorial
=============================================

Siga passo a passo as instruções desse tutorial, para
entender como executar o projeto, e o que cada comando
do Makefile faz. Linhas que iniciam com '$' indicam comandos
a serem executados no terminal (na pasta do projeto). 

Na pasta inicial do projeto, temos:
	- Makefile
	- boot1.asm

O Makefile é uma espécie de script lido pelo comando 'make', que
procura o comando passado como parâmetro dentro do Makefile e o
executa.

Portanto 'make <comando>' executa algum comando definido dentro
do Makefile. Nesse projeto, vários comandos foram definidos para
facilitar a vida de vocês (alunos).


Execute os seguintes comandos para se familiarizar com o ambiente
de desenvolvimento do projeto:

-----------------------------------------------------------------------

# cria uma imagem de disco com 100 (default) blocos/setores,
# onde cada setor, possui 512 bytes (default) ou seja, o disco tem 50KB.
# OBS: imagem está preenchida com zeros

	$ make mydisk

# roda o nasm em cima do arquivo boot1.asm (default),
# gerando um binário de padrão flat, chamado boot1.bin

	$ make boot1

# coloca o primeiro estágio do bootloader em formato binário no
# primeiro setor da imagem de disco.

	$ make write_boot1

# roda o qemu, usando a sua imagem de disco.

	$ make launchqemu

# limpa a pasta do projeto, removendo arquivos gerados pelo 'make', como
# binários e imagens de disco. Útil ao rodar de novo o projeto.

	$ make clean


-----------------------------------------------------------------------

Os seguintes comandos servem como auxílio para compreender exatamente
o que o código está fazendo.

# mostra um hexdump do disco na tela, para checar se o seu bootloader 
# está ultrapassando os 512 bytes permitidos para um bootsector. Esse
# comando é útil para entender melhor o que está acontecendo no disco,
# principalmente a posição onde os programas estão na imagem.

	$ make hexdump

# Roda o disassembler do nasm, transformando o código (à principio do
# primeiro estágio do bootloader) binário em assembly e jogando o código
# na tela. Pode ser útil ao tentar entender o que uma determinada macro
# do nasm faz, ou como o nasm funciona em geral.

	$ make disasm


-----------------------------------------------------------------------

E para conviniência...

# Roda todo o projeto automaticamente, deixando mais rápido o processo
# de desenvolvimento

	$ make all

Utilizando esse comando, tudo que você precisa fazer é modificar os arquivos
e executar 'make all', e automaticamente tudo será feito e o qemu chamado.


OBS: Mesmo com o 'make all' facilitando muito a vida, entenda todo o processo
antes de começar a usá-lo.

-----------------------------------------------------------------------

Todo esse processo pode ser customizado modificando o Makefile,
Exemplo:

Se voce quiser que seu disco tenha 50 setores, ao invés do default (100),
voce pode alterar a variavel 'disksize' no proprio Makefile, ou pode passar
uma opção ao rodar o comando 'make' que faz isso automaticamente (porém só
para essa instância da execução):

	$ make mydisk disksize=50

O comando make também aceita mais de um comando ao mesmo tempo, executando-os em
ordem, por exemplo:
	
	$ make clean mydisk

Esse comando limpa a pasta do projeto e cria uma nova imagem de disco.

------------------------------------------------------------------------


		Projeto
=============================================

O projeto consiste em modificar o código do boot1.asm, para que este
carregue na memória o segundo estágio do bootloader (que deve ser outro
arquivo criado para o projeto), e este por sua vez, deve carregar o kernel
escrito por vocês em assembly. O kernel é um programa normal em assembly,
que deverá imprimir na tela uma string com o nome do SO de vocês.

Existem várias formas de fazer isso, porém para facilitar a vida, vocês farão
um bootloader de 2 estágio, que sabe exatamente onde está o kernel no disco (setor),
e carregará esse kernel num endereço fixo da memória, pulando para lá em seguida.

Para usar o Makefile com o segundo estágio do bootloader e com o kernel, é necessário
informar alguns detalhes, como aonde eles irão ser escritos no disco, o nome dos arquivos,
etc.
