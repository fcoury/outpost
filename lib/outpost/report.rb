module Outpost
  class Report

    # Sumarizes the list of statuses in a single status only.
    # The logic is rather simple - it will return the lowest status
    # present in the list.
    #
    # Examples:
    #
    # if passed [:up, :up, :up], will result on :up
    # if passed [:up, :down, :up], will result on :down
    def self.sumarize(status_list)
      # FIXME I think there's a way to do this on the logic itself
      # but will get back on this later
      return :down if status_list.empty?

      final_status = status_list.inject(true) do |result, status|
        result &&= (status == :up)
      end

      final_status ? :up : :down
    end
  end
end
