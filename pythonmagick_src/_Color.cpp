
// Boost Includes ==============================================================
#include <boost/python.hpp>
#include <boost/cstdint.hpp>

// Includes ====================================================================
#include <Magick++/Color.h>

// Using =======================================================================
using namespace boost::python;

// Module ======================================================================
void Export_pyste_src_Color()
{
    class_< Magick::Color >("Color", init<  >())
        .def(init< MagickCore::Quantum, MagickCore::Quantum, MagickCore::Quantum >())
        .def(init< MagickCore::Quantum, MagickCore::Quantum, MagickCore::Quantum, MagickCore::Quantum >())
        .def(init< const std::string& >())
        .def(init< const char* >())
        .def(init< const Magick::Color& >())
        .def(init< const MagickCore::PixelPacket& >())
        .def("redQuantum", (void (Magick::Color::*)(MagickCore::Quantum) )&Magick::Color::redQuantum)
        .def("redQuantum", (MagickCore::Quantum (Magick::Color::*)() const)&Magick::Color::redQuantum)
        .def("greenQuantum", (void (Magick::Color::*)(MagickCore::Quantum) )&Magick::Color::greenQuantum)
        .def("greenQuantum", (MagickCore::Quantum (Magick::Color::*)() const)&Magick::Color::greenQuantum)
        .def("blueQuantum", (void (Magick::Color::*)(MagickCore::Quantum) )&Magick::Color::blueQuantum)
        .def("blueQuantum", (MagickCore::Quantum (Magick::Color::*)() const)&Magick::Color::blueQuantum)
        .def("alphaQuantum", (void (Magick::Color::*)(MagickCore::Quantum) )&Magick::Color::alphaQuantum)
        .def("alphaQuantum", (MagickCore::Quantum (Magick::Color::*)() const)&Magick::Color::alphaQuantum)
        .def("alpha", (void (Magick::Color::*)(double) )&Magick::Color::alpha)
        .def("alpha", (double (Magick::Color::*)() const)&Magick::Color::alpha)
        .def("isValid", (void (Magick::Color::*)(bool) )&Magick::Color::isValid)
        .def("isValid", (bool (Magick::Color::*)() const)&Magick::Color::isValid)
        .def("intensity", &Magick::Color::intensity)
        .def("scaleDoubleToQuantum", &Magick::Color::scaleDoubleToQuantum)
        .def("scaleQuantumToDouble", (double (*)(const MagickCore::Quantum))&Magick::Color::scaleQuantumToDouble)
        .def("scaleQuantumToDouble", (double (*)(const double))&Magick::Color::scaleQuantumToDouble)
        .staticmethod("scaleDoubleToQuantum")
        .staticmethod("scaleQuantumToDouble")
        .def( self > self )
        .def( self < self )
        .def( self == self )
        .def( self != self )
        .def( self <= self )
        .def( self >= self )
        .def("to_std_string", &Magick::Color::operator std::string)
        .def("to_MagickCore_PixelPacket", &Magick::Color::operator MagickCore::PixelPacket)
    ;

implicitly_convertible<std::string,Magick::Color>();}

