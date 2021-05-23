FROM siemersn/nosharstudio
##FROM noshar:latest


RUN /usr/local/bin/pip3 install biopython 
RUN rm /usr/local/bin/python ; ln -s /usr/local/bin/python3 /usr/local/bin/python
RUN rm /usr/local/bin/pip; ln -s /usr/local/bin/pip3 /usr/local/bin/pip

## nosharstudio has rich R and newer python installed first in path

################################################################
## Tracer stuff

#Trinity - depends on zlib1g-dev and openjdk-8-jre installed previously
RUN wget   https://github.com/trinityrnaseq/trinityrnaseq/releases/download/v2.11.0/trinityrnaseq-v2.11.0.FULL.tar.gz
RUN tar xvzf trinityrnaseq-v2.11.0.FULL.tar.gz  && rm trinityrnaseq-v2.11.0.FULL.tar.gz
RUN ls -l
RUN cd trinityrnaseq-v2.11.0  && make

#IgBLAST, plus the setup of its super weird internal_data thing. don't ask. just needs to happen
#and then on top of that, the environmental variable thing facilitates the creation of a shell wrapper. fun
RUN wget   ftp://ftp.ncbi.nih.gov/blast/executables/igblast/release/1.7.0/ncbi-igblast-1.7.0-x64-linux.tar.gz
RUN tar -xzvf ncbi-igblast-1.7.0-x64-linux.tar.gz && rm ncbi-igblast-1.7.0-x64-linux.tar.gz
RUN cd ncbi-igblast-1.7.0/bin/ && wget   -r ftp://ftp.ncbi.nih.gov/blast/executables/igblast/release/old_internal_data && \
	wget   -r ftp://ftp.ncbi.nih.gov/blast/executables/igblast/release/old_optional_file && \
	mv ftp.ncbi.nih.gov/blast/executables/igblast/release/old_internal_data . && \
	mv ftp.ncbi.nih.gov/blast/executables/igblast/release/old_optional_file . && \
	rm -r ftp.ncbi.nih.gov

#aligners - kallisto and salmon
RUN wget   https://github.com/pachterlab/kallisto/releases/download/v0.43.1/kallisto_linux-v0.43.1.tar.gz
RUN tar -xzvf kallisto_linux-v0.43.1.tar.gz && rm kallisto_linux-v0.43.1.tar.gz
#RUN wget   https://github.com/COMBINE-lab/salmon/releases/download/v0.8.2/Salmon-0.8.2_linux_x86_64.tar.gz
#RUN tar -xzvf Salmon-0.8.2_linux_x86_64.tar.gz && rm Salmon-0.8.2_linux_x86_64.tar.gz

#graphviz, which lives in a sufficient form (dot/neato) in apt-get apparently
RUN apt-get -y install graphviz


## update python if necessary
RUN pip3 install numpy --upgrade
RUN pip3 install pyparsing --upgrade


RUN wget   https://github.com/Teichlab/tracer/archive/refs/heads/master.zip && unzip master.zip && mv tracer-master tracer
RUN cd tracer && pip install -r docker_helper_files/requirements_stable.txt && python3 setup.py install
##RUN cd tracer && python3 setup.py install

#obtaining the transcript sequences. no salmon/kallisto indices as they make dockerhub unhappy for some reason
RUN mkdir GRCh38 && cd GRCh38 && wget   ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_27/gencode.v27.transcripts.fa.gz && \
	gunzip gencode.v27.transcripts.fa.gz && python3 ../tracer/docker_helper_files/gencode_parse.py gencode.v27.transcripts.fa && rm gencode.v27.transcripts.fa
RUN mkdir GRCm38 && cd GRCm38 && wget  ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M15/gencode.vM15.transcripts.fa.gz && \
	gunzip gencode.vM15.transcripts.fa.gz && python3 ../tracer/docker_helper_files/gencode_parse.py gencode.vM15.transcripts.fa && rm gencode.vM15.transcripts.fa

#placing a preconfigured tracer.conf in ~/.tracerrc
RUN cp tracer/docker_helper_files/docker_tracer.conf ~/.tracerrc

#this is a tracer container, so let's point it at a tracer wrapper that sets the silly IgBLAST environment variable thing
## there's a change in IUPAC call that needs fixing due to python version

## File "/usr/local/lib/python3.8/site-packages/tracer-0.5-py3.8.egg/tracerlib/tracer_func.py", line 29, in <module>
##     from Bio.Alphabet import IUPAC
##   File "/usr/local/lib/python3.8/site-packages/Bio/Alphabet/__init__.py", line 20, in <module>
##     raise ImportError(
## ImportError: Bio.Alphabet has been removed from Biopython. In many cases, the alphabet can simply be ignored and removed from scripts. In a few cases, you may need to specify the ``molecule_type`

## don't enable ENTRYPOINT BECAUSE OF THAT,
## DIG up and set the igblast environment variable

##ENTRYPOINT ["bash", "tracer/docker_helper_files/docker_wrapper.sh"]



RUN pip install RSeQC
RUN rm /usr/local/bin/python ; ln -s /usr/local/bin/python3 /usr/local/bin/python
RUN rm /usr/local/bin/pip; ln -s /usr/local/bin/pip3 /usr/local/bin/pip


################################################################
## end of tracer stuff

################################################################
## delete this network stuff -doesn't fix the runtime problem
##RUN wget --quiet https://files.pythonhosted.org/packages/b0/21/adfbf6168631e28577e4af9eb9f26d75fe72b2bb1d33762a5f2c425e6c2a/networkx-2.5.1.tar.gz && tar xzf networkx-2.5.1.tar.gz && cd networkx-2.5.1 && python setup.py install
##RUN pip3 install networx[all]
##RUN pip install git://github.com/networkx/networkx.git#egg=networkx
################################################################

## any stuff from github

## RUN Rscript -e  'devtools::install_github("hylasD/tSpace", build = TRUE, build_opts = c("--no-resave-data", "--no-manual"), force = T)'





