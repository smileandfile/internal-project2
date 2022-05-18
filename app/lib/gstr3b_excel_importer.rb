require 'roo'
INTER_STATE_START_VALUE = 6

#3.1 Details of Outward Supplies and inward supplies liable to reverse charge  

class Gstr3bExcelImporter
  @header = [] # header of an excel sheet

  # parse the excel sheet into the JSON
  #
  # @param file excel sheet file
  # @params Hash of {file: excel__sheet.xlxs }
  # @return array of hash of SAVE_GSTR3B data
  def import(options)
    spreadsheet = Roo::Spreadsheet.open(options[:file], extension: :xlsx)
    unreg_details = inter_state_supplies(spreadsheet.sheet(1))
    comp_details = inter_state_supplies(spreadsheet.sheet(2))
    uin_details = inter_state_supplies(spreadsheet.sheet(3))
    @@sheet = spreadsheet.sheet(0)
    gstin_number = cell_value(7, 'D').to_s + cell_value(7, 'E').to_s + cell_value(7, 'F').to_s + cell_value(7, 'G').to_s  \
                       + cell_value(7, 'H').to_s + cell_value(7, 'I').to_s + cell_value(7, 'J').to_s + cell_value(7, 'K').to_s \
                       + cell_value(7, 'L').to_s + cell_value(7, 'M').to_s + cell_value(7, 'N').to_s + cell_value(7, 'O').to_s \
                       + cell_value(7, 'P').to_s + cell_value(7, 'Q').to_s + cell_value(7, 'R').to_s
    gstr3b = {
      "gstin": gstin_number,
      "return_period": cell_value(5, 'Q').to_s + cell_value(4, 'Q').to_s,
      "gstr3b": {
        "sup_details": {
          "osup_det": {
            "txval":  cell_value(29, 'D'),
            "iamt": cell_value(29, 'G'),
            "camt": cell_value(29, 'J'),
            "samt": cell_value(29, 'M'),
            "csamt": cell_value(29, 'P')
          },
          "osup_zero": {
            "txval": cell_value(34, 'D'),
            "iamt": cell_value(34, 'G'),
            "camt": cell_value(34, 'J'),
            "samt": cell_value(34, 'M'),
            "csamt": cell_value(34, 'P')
          },
          "osup_nil_exmp": {
            "txval": cell_value(38, 'D'),
            "iamt": cell_value(38, 'G'),
            "camt": cell_value(38, 'J'),
            "samt": cell_value(38, 'M'),
            "csamt": cell_value(38, 'P')
          },
          "isup_rev": {
            "txval": cell_value(49, 'D'),
            "iamt": cell_value(49, 'G'),
            "camt": cell_value(49, 'J'),
            "samt": cell_value(29, 'M'),
            "csamt": cell_value(29, 'P')
          },
          "osup_nongst": {
            "txval": cell_value(52, 'D'),
            "iamt": cell_value(52, 'G'),
            "camt": cell_value(52, 'J'),
            "samt": cell_value(52, 'M'),
            "csamt": cell_value(52, 'P')
          }
        },
        "inter_sup": {
          "unreg_details": unreg_details,
          "comp_details": comp_details,
          "uin_details": uin_details
        },
        "itc_elg": {
          "itc_avl": [
            {
              "ty": "IMPG",
              "iamt": cell_value(71, 'D'),
              "camt": cell_value(71, 'H'),
              "samt": cell_value(71, 'L'),
              "csamt": cell_value(71, 'P')
            },
            {
              "ty": "IMPS",
              "iamt": cell_value(72, 'D'),
              "camt": cell_value(72, 'H'),
              "samt": cell_value(72, 'L'),
              "csamt": cell_value(72, 'P')
            },
            {
              "ty": "ISRC",
              "iamt": cell_value(73, 'D'),
              "camt": cell_value(73, 'H'),
              "samt": cell_value(73, 'L'),
              "csamt": cell_value(73, 'P')
            },
            {
              "ty": "ISD",
              "iamt": cell_value(74, 'D'),
              "camt": cell_value(74, 'H'),
              "samt": cell_value(74, 'L'),
              "csamt": cell_value(74, 'P')
            },
            {
              "ty": "OTH",
              "iamt": cell_value(75, 'D'),
              "camt": cell_value(75, 'H'),
              "samt": cell_value(75, 'L'),
              "csamt": cell_value(75, 'P')
            }
          ],
          "itc_rev": [
            {
              "ty": "RUL",
              "iamt": cell_value(78, 'D'),
              "camt": cell_value(78, 'H'),
              "samt": cell_value(78, 'L'),
              "csamt": cell_value(78, 'P')
            },
            {
              "ty": "OTH",
              "iamt": cell_value(79, 'D'),
              "camt": cell_value(79, 'H'),
              "samt": cell_value(79, 'L'),
              "csamt": cell_value(79, 'P')
            }
          ],
          "itc_net": {
            "iamt": cell_value(81, 'D'),
            "camt": cell_value(81, 'H'),
            "samt": cell_value(81, 'L'),
            "csamt": cell_value(81, 'P')
          }
        },
        "inward_sup": {
          "isup_details": [
            {
              "ty": "GST",
              "inter": cell_value(92, 'E'),
              "intra": cell_value(92, 'L')
            },
            {
              "ty": "NONGST",
              "inter": cell_value(93, 'E'),
              "intra": cell_value(93, 'E')
            }
          ]
        },
        "intr_ltfee": {
          "intr_details": {
            "iamt": cell_value(92, 'F'),
            "camt": cell_value(92, 'H'),
            "samt": cell_value(92, 'J'),
            "csamt": cell_value(92, 'L')
          }
        }
      }

      }
    gstr3b
  end

  def cell_value(row, column)
    @@sheet.cell(row, column).nil? ? 0 : @@sheet.cell(row, column)
  end

  def inter_state_supplies(sheet)
    state_array = []
    (INTER_STATE_START_VALUE..sheet.last_row - 2).each do |row|
      state_array.push({ "pos": sheet.cell(row, 'D').to_s, "txval": sheet.cell(row, 'I'), "iamt": sheet.cell(row, 'N') }) if sheet.row(row).any?
    end
    state_array
  end


end
