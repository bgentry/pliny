require "spec_helper"

describe Pliny::Metrics do
  before do
    @io = StringIO.new
    Pliny.stdout = @io
    stub(@io).print

    stub(Config).app_name { 'pliny' }
  end

  context "#count" do
    it "counts a single key with a default value" do
      mock(@io).print "count#pliny.foo=1\n"
      Pliny.count(:foo)
    end

    it "counts a single key with a provided value" do
      mock(@io).print "count#pliny.foo=2\n"
      Pliny.count(:foo, value: 2)
    end

    it "counts multiple keys" do
      mock(@io).print "count#pliny.foo=1 count#pliny.bar=1\n"
      Pliny.count(:foo, :bar)
    end
  end

  context "#measure" do
    before do
      Timecop.freeze(Time.now)
    end

    it "measures a single key" do
      mock(@io).print "measure#pliny.foo=0.000\n"
      Pliny.measure(:foo) do
      end
    end

    it "measures a single key over a minute" do
      mock(@io).print "measure#pliny.foo=60.000\n"
      Pliny.measure(:foo) do
        Timecop.travel(60)
      end
    end

    it "measures multiple keys" do
      mock(@io).print "measure#pliny.foo=0.000 measure#pliny.bar=0.000\n"
      Pliny.measure(:foo, :bar) do
      end
    end
  end
end
