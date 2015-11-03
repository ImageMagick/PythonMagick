
// Boost Includes ==============================================================
#include <boost/python.hpp>
#include <boost/cstdint.hpp>

// Includes ====================================================================
#include <Magick++/Drawable.h>

// Declarations ================================================================
#include <Magick++.h>

// Using =======================================================================
using namespace boost::python;

namespace  {

struct Magick_DrawableDashArray_Wrapper: Magick::DrawableDashArray
{
    Magick_DrawableDashArray_Wrapper(PyObject* py_self_, const double* p0):
        Magick::DrawableDashArray(p0), py_self(py_self_) {}

    Magick_DrawableDashArray_Wrapper(PyObject* py_self_, const size_t* p0):
        Magick::DrawableDashArray(p0), py_self(py_self_) {}

    Magick_DrawableDashArray_Wrapper(PyObject* py_self_, const Magick::DrawableDashArray& p0):
        Magick::DrawableDashArray(p0), py_self(py_self_) {}


    PyObject* py_self;
};


}// namespace 


// Module ======================================================================
void Export_pyste_src_DrawableDashArray()
{
    class_< Magick::DrawableDashArray, Magick_DrawableDashArray_Wrapper >("DrawableDashArray", init< const double* >())
        .def(init< const size_t* >())
        .def(init< const Magick::DrawableDashArray& >())
    ;
implicitly_convertible<Magick::DrawableDashArray,Magick::Drawable>();
}

