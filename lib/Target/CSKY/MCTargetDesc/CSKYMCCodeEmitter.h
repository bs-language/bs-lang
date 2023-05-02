//===-- CSKYMCCodeEmitter.cpp - CSKY Code Emitter interface ---------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements the CSKYMCCodeEmitter class.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_CSKY_MCTARGETDESC_CSKYMCCODEEMITTER_H
#define LLVM_LIB_TARGET_CSKY_MCTARGETDESC_CSKYMCCODEEMITTER_H

#include "MCTargetDesc/CSKYFixupKinds.h"
#include "MCTargetDesc/CSKYMCExpr.h"
#include "llvm/MC/MCCodeEmitter.h"
#include "llvm/MC/MCContext.h"

namespace llvm {

class MCInstrInfo;

class CSKYMCCodeEmitter : public MCCodeEmitter {
  MCContext &Ctx;
  const MCInstrInfo &MII;

public:
  CSKYMCCodeEmitter(MCContext &Ctx, const MCInstrInfo &MII)
      : Ctx(Ctx), MII(MII) {}

  ~CSKYMCCodeEmitter() {}

  void encodeInstruction(const MCInst &Inst, raw_ostream &OS,
                         SmallVectorImpl<MCFixup> &Fixups,
                         const MCSubtargetInfo &STI) const override;

  // Generated by tablegen.
  uint64_t getBinaryCodeForInstr(const MCInst &MI,
                                 SmallVectorImpl<MCFixup> &Fixups,
                                 const MCSubtargetInfo &STI) const;

  // Default encoding method used by tablegen.
  unsigned getMachineOpValue(const MCInst &MI, const MCOperand &MO,
                             SmallVectorImpl<MCFixup> &Fixups,
                             const MCSubtargetInfo &STI) const;

  template <int shift = 0>
  unsigned getImmOpValue(const MCInst &MI, unsigned Idx,
                         SmallVectorImpl<MCFixup> &Fixups,
                         const MCSubtargetInfo &STI) const {
    const MCOperand &MO = MI.getOperand(Idx);
    if (MO.isImm())
      return (MO.getImm() >> shift);

    assert(MO.isExpr() && "Unexpected MO type.");

    MCFixupKind Kind = getTargetFixup(MO.getExpr());
    Fixups.push_back(MCFixup::create(0, MO.getExpr(), Kind, MI.getLoc()));
    return 0;
  }

  unsigned getRegSeqImmOpValue(const MCInst &MI, unsigned Idx,
                               SmallVectorImpl<MCFixup> &Fixups,
                               const MCSubtargetInfo &STI) const;

  unsigned getRegisterSeqOpValue(const MCInst &MI, unsigned Op,
                                 SmallVectorImpl<MCFixup> &Fixups,
                                 const MCSubtargetInfo &STI) const;

  unsigned getOImmOpValue(const MCInst &MI, unsigned Idx,
                          SmallVectorImpl<MCFixup> &Fixups,
                          const MCSubtargetInfo &STI) const;

  unsigned getImmOpValueIDLY(const MCInst &MI, unsigned Idx,
                             SmallVectorImpl<MCFixup> &Fixups,
                             const MCSubtargetInfo &STI) const;

  unsigned getImmJMPIX(const MCInst &MI, unsigned Idx,
                       SmallVectorImpl<MCFixup> &Fixups,
                       const MCSubtargetInfo &STI) const;

  unsigned getImmOpValueMSBSize(const MCInst &MI, unsigned Idx,
                                SmallVectorImpl<MCFixup> &Fixups,
                                const MCSubtargetInfo &STI) const;

  unsigned getImmShiftOpValue(const MCInst &MI, unsigned Idx,
                              SmallVectorImpl<MCFixup> &Fixups,
                              const MCSubtargetInfo &STI) const {
    const MCOperand &MO = MI.getOperand(Idx);
    assert(MO.isImm() && "Unexpected MO type.");
    return 1 << MO.getImm();
  }

  MCFixupKind getTargetFixup(const MCExpr *Expr) const;

  template <llvm::CSKY::Fixups FIXUP>
  unsigned getBranchSymbolOpValue(const MCInst &MI, unsigned Idx,
                                  SmallVectorImpl<MCFixup> &Fixups,
                                  const MCSubtargetInfo &STI) const {
    const MCOperand &MO = MI.getOperand(Idx);

    if (MO.isImm())
      return MO.getImm() >> 1;

    assert(MO.isExpr() && "Unexpected MO type.");

    MCFixupKind Kind = MCFixupKind(FIXUP);
    if (MO.getExpr()->getKind() == MCExpr::Target)
      Kind = getTargetFixup(MO.getExpr());

    Fixups.push_back(MCFixup::create(0, MO.getExpr(), Kind, MI.getLoc()));
    return 0;
  }

  template <llvm::CSKY::Fixups FIXUP>
  unsigned getConstpoolSymbolOpValue(const MCInst &MI, unsigned Idx,
                                     SmallVectorImpl<MCFixup> &Fixups,
                                     const MCSubtargetInfo &STI) const {
    const MCOperand &MO = MI.getOperand(Idx);
    assert(MO.isExpr() && "Unexpected MO type.");

    MCFixupKind Kind = MCFixupKind(FIXUP);
    if (MO.getExpr()->getKind() == MCExpr::Target)
      Kind = getTargetFixup(MO.getExpr());

    Fixups.push_back(MCFixup::create(0, MO.getExpr(), Kind, MI.getLoc()));
    return 0;
  }

  template <llvm::CSKY::Fixups FIXUP>
  unsigned getDataSymbolOpValue(const MCInst &MI, unsigned Idx,
                                SmallVectorImpl<MCFixup> &Fixups,
                                const MCSubtargetInfo &STI) const {
    const MCOperand &MO = MI.getOperand(Idx);
    assert(MO.isExpr() && "Unexpected MO type.");

    MCFixupKind Kind = MCFixupKind(FIXUP);
    if (MO.getExpr()->getKind() == MCExpr::Target)
      Kind = getTargetFixup(MO.getExpr());

    Fixups.push_back(MCFixup::create(0, MO.getExpr(), Kind, MI.getLoc()));
    return 0;
  }

  unsigned getCallSymbolOpValue(const MCInst &MI, unsigned Idx,
                                SmallVectorImpl<MCFixup> &Fixups,
                                const MCSubtargetInfo &STI) const {
    const MCOperand &MO = MI.getOperand(Idx);
    assert(MO.isExpr() && "Unexpected MO type.");

    MCFixupKind Kind = MCFixupKind(CSKY::fixup_csky_pcrel_imm26_scale2);
    if (MO.getExpr()->getKind() == MCExpr::Target)
      Kind = getTargetFixup(MO.getExpr());

    Fixups.push_back(MCFixup::create(0, MO.getExpr(), Kind, MI.getLoc()));
    return 0;
  }

  unsigned getBareSymbolOpValue(const MCInst &MI, unsigned Idx,
                                SmallVectorImpl<MCFixup> &Fixups,
                                const MCSubtargetInfo &STI) const {
    const MCOperand &MO = MI.getOperand(Idx);
    assert(MO.isExpr() && "Unexpected MO type.");

    MCFixupKind Kind = MCFixupKind(CSKY::fixup_csky_pcrel_imm18_scale2);
    if (MO.getExpr()->getKind() == MCExpr::Target)
      Kind = getTargetFixup(MO.getExpr());

    Fixups.push_back(MCFixup::create(0, MO.getExpr(), Kind, MI.getLoc()));
    return 0;
  }

  void expandJBTF(const MCInst &MI, raw_ostream &OS,
                  SmallVectorImpl<MCFixup> &Fixups,
                  const MCSubtargetInfo &STI) const;
  void expandNEG(const MCInst &MI, raw_ostream &OS,
                 SmallVectorImpl<MCFixup> &Fixups,
                 const MCSubtargetInfo &STI) const;
  void expandRSUBI(const MCInst &MI, raw_ostream &OS,
                   SmallVectorImpl<MCFixup> &Fixups,
                   const MCSubtargetInfo &STI) const;
};

} // namespace llvm

#endif // LLVM_LIB_TARGET_CSKY_MCTARGETDESC_CSKYMCCODEEMITTER_H
