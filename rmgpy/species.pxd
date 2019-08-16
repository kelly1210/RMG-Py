###############################################################################
#                                                                             #
# RMG - Reaction Mechanism Generator                                          #
#                                                                             #
# Copyright (c) 2002-2019 Prof. William H. Green (whgreen@mit.edu),           #
# Prof. Richard H. West (r.west@neu.edu) and the RMG Team (rmg_dev@mit.edu)   #
#                                                                             #
# Permission is hereby granted, free of charge, to any person obtaining a     #
# copy of this software and associated documentation files (the 'Software'),  #
# to deal in the Software without restriction, including without limitation   #
# the rights to use, copy, modify, merge, publish, distribute, sublicense,    #
# and/or sell copies of the Software, and to permit persons to whom the       #
# Software is furnished to do so, subject to the following conditions:        #
#                                                                             #
# The above copyright notice and this permission notice shall be included in  #
# all copies or substantial portions of the Software.                         #
#                                                                             #
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  #
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    #
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE #
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      #
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     #
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         #
# DEALINGS IN THE SOFTWARE.                                                   #
#                                                                             #
###############################################################################

cimport numpy

cimport rmgpy.constants as constants
from rmgpy.quantity cimport ScalarQuantity, ArrayQuantity
from rmgpy.thermo.model cimport HeatCapacityModel
from rmgpy.statmech.conformer cimport Conformer
from rmgpy.kinetics.model cimport TunnelingModel
from rmgpy.molecule.molecule cimport Atom, Bond, Molecule

################################################################################

cdef class Species:
    
    cdef public int index
    cdef public str label
    cdef public object thermo
    cdef public Conformer conformer
    cdef public object transportData
    cdef public list molecule
    cdef public ScalarQuantity _molecularWeight
    cdef public bint reactive
    cdef public object energyTransferModel
    cdef public dict props
    cdef public str aug_inchi
    cdef public float symmetryNumber
    cdef public bint isSolvent
    cdef public int creationIteration
    cdef public bint explicitlyAllowed
    cdef str _formula
    cdef str _fingerprint
    cdef str _inchi
    cdef str _smiles

    cpdef generate_resonance_structures(self, bint keep_isomorphic=?, bint filter_structures=?)
    
    cpdef bint isIsomorphic(self, other, bint generateInitialMap=?, bint strict=?) except -2

    cpdef bint isIdentical(self, other, bint strict=?) except -2

    cpdef bint is_structure_in_list(self, list species_list) except -2
    
    cpdef fromAdjacencyList(self, adjlist)
    cpdef fromSMILES(self, smiles)
    
    cpdef toAdjacencyList(self)
    
    cpdef bint containsSurfaceSite(self) except -2

    cpdef bint isSurfaceSite(self) except -2

    cpdef bint hasStatMech(self) except -2

    cpdef bint hasThermo(self) except -2

    cpdef double getPartitionFunction(self, double T) except -1

    cpdef double getHeatCapacity(self, double T) except -100000000

    cpdef double getEnthalpy(self, double T) except 100000000

    cpdef double getEntropy(self, double T) except -100000000

    cpdef double getFreeEnergy(self, double T) except 100000000

    cpdef numpy.ndarray getSumOfStates(self, numpy.ndarray Elist)

    cpdef numpy.ndarray getDensityOfStates(self, numpy.ndarray Elist)

    cpdef double calculateCp0(self) except -1

    cpdef double calculateCpInf(self) except -1

    cpdef bint has_reactive_molecule(self) except -1

    cpdef Species copy(self, bint deep=?)

    cpdef set_structure(self, str structure)
    
################################################################################

cdef class TransitionState:
    
    cdef public str label
    cdef public Conformer conformer
    cdef public ScalarQuantity _frequency
    cdef public int degeneracy
    cdef public TunnelingModel tunneling

    cpdef double getPartitionFunction(self, double T) except -1

    cpdef double getHeatCapacity(self, double T) except -100000000

    cpdef double getEnthalpy(self, double T) except 100000000

    cpdef double getEntropy(self, double T) except -100000000

    cpdef double getFreeEnergy(self, double T) except 100000000

    cpdef numpy.ndarray getSumOfStates(self, numpy.ndarray Elist)

    cpdef numpy.ndarray getDensityOfStates(self, numpy.ndarray Elist)
    
    cpdef double calculateTunnelingFactor(self, double T) except -1
    
    cpdef numpy.ndarray calculateTunnelingFunction(self, numpy.ndarray Elist)
