#!/usr/bin/bash

# Diretório de saída da análise
OUTDIR='/'

mkdir -p 'analysis'

if [ -d 'analysis' ]; then
	echo 'Iniciando coleta...'

	# Captura de dump da memória RAM
	sudo dd if=/dev/mem of='analysis/mem_dump.bin' bs=1M count=100

	# Captura de dump da memória ROM e BIOS
	dmesg | grep -i 'BIOS' > 'analysis/rom_info.txt'

	# Coleta de informações do processador
	cat /proc/cpuinfo > 'analysis/cpu_info.txt'

	# Coleta de informações da versão do sistema
	cat /proc/version > 'analysis/version_info.txt'

	# Coleta de informações sobre partições da memória ROM
	cat /proc/partitions > 'analysis/partitions_info.txt'

	# Coleta do tempo ativo do sistema(em formato Unix)
	cat /proc/uptime > 'analysis/uptime_info.txt'

	# Coleta de informações da memória RAM
	cat /proc/meminfo > 'analysis/mem_info.txt'

	# Coleta de informações sobre a placa de rede
	ifconfig -a > 'analysis/network_info.txt'

	# Compactando os arquivos
	zip -r 'analysis/forensic_data.zip' 'analysis'
	sudo mv "analysis/forensic_data.zip" "$OUTDIR"
	sudo rm -r 'analysis'

	echo 'Coleta concluída. Os dados estão em' $OUTDIR.
else
	echo 'Falha na coleta!'
	exit 1
fi
