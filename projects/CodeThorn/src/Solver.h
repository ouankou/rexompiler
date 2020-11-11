#ifndef SOLVER_H
#define SOLVER_H

namespace CodeThorn {

  class CTAnalysis;

/*! 
  * \author Marc Jasper
  * \date 2017.
  * \brief Solver interface
 */
  class Solver {

  friend class CTAnalysis;

  public:
    Solver();
    Solver(CTAnalysis* analyzer);
    virtual void run() = 0;
    virtual int getId() = 0;

  protected:
    virtual void setAnalyzer(CTAnalysis* analyzer);
    void initDiagnostics(Sawyer::Message::Facility& logger, int solverId);

    CTAnalysis* _analyzer = nullptr;
  };

} // end of namespace CodeThorn

#endif
