#!/usr/bin/env python

from __future__ import print_function
import argparse
import Bio.PDB
import gzip
import sys

def parse_input(inputfile,chains,atomName):
	parser = Bio.PDB.PDBParser()
	pdb = parser.get_structure('Protein',gzip.open(inputfile,"r"))
	model = pdb[0]
	atoms = []

	chosen = chains

	if (chosen[0] == 'Max'):
		chosen = 'A'
		max = 0

		for chain in model:
			if (chain.get_id() != ' ' and max < len(chain)):
				ppb=Bio.PDB.CaPPBuilder(7)
				for pp in ppb.build_peptides(chain):
					if pp.get_ca_list():
						max = len(chain)
						chosen = chain
						break

		for residue in chosen:
			if (Bio.PDB.Polypeptide.is_aa(residue)):
				(het,sid,ic) = residue.id
				if (het == ' ' and atomName in residue):
					atoms.append(residue[atomName])

	elif (chosen[0] == 'All'):
		for chain in model:
			if (chain.get_id() != ' '):
				for residue in chain:
					if (Bio.PDB.Polypeptide.is_aa(residue)):
						(het,sid,ic) = residue.id
						if (het == ' ' and atomName in residue):
							atoms.append(residue[atomName])

	else:
		for chain in model:
			if (chain.get_id() != ' ' and chain.get_id() in chosen):
				for residue in chain:
					if (Bio.PDB.Polypeptide.is_aa(residue)):
						(het,sid,ic) = residue.id
						if (het == ' ' and atomName in residue):
							atoms.append(residue[atomName])


	print("Atoms: {0}".format(len(atoms)),file=sys.stdout)
	return atoms

def generate_graph(output,atoms,dist):
	edges=[]
	for i in range(0,len(atoms)):
		for j in range(i+1,len(atoms)):
			if dist > atoms[i] - atoms[j]:
				edges.append([i,j])

	edgeNum = len(edges)
	nodeNum = max(max(edges,key=lambda x:(x[1] if x[1]>x[0] else x[0]))) + 1
	
	# write header
	print("{0} {1}".format(nodeNum,edgeNum),file=output)

	# write edges
	for edge in edges:
		print("{0} {1}".format(edge[0],edge[1]),file=output)

def main():
	parser = argparse.ArgumentParser(prog='pdbtograph',description='Generates graph representation of atoms contained in a protein chain')
	parser.add_argument('inputfile',type=str)
	parser.add_argument('outputfile',type=argparse.FileType('w'))
	parser.add_argument('--max-dist','-d',dest='dist',nargs='?',type=float,default=6)
	parser.add_argument('--atom-name','-a',dest='atom',default='CA')
	parser.add_argument('--chain','-c',dest='chain',nargs='*',default=['Max'],choices=['Max','All','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'])
	args = parser.parse_args()
	atoms = parse_input( args.inputfile, args.chain, args.atom)
	generate_graph( args.outputfile, atoms, args.dist)
	args.outputfile.close()

if __name__ == '__main__':
	main()

