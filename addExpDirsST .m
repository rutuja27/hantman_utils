
label_jab_file = '~/Downloads/M173_20150423.jab'; % jab file to import exp/labels from.
in_jab_file = '~/work/JAABABugs/rutuja.jab'; % jab file to add exp/labels.
out_jab_file = '~/work/JAABABugs/rutuja_out.jab'; % jab file to add exp/labels.

data = JLabelData();
data.isInteractive = false;
data.openJabFile(in_jab_file,false);

Q = load(label_jab_file,'-mat');

origExpDirNames = Q.x.expDirNames;
origLabels = Q.x.labels;

assert(numel(origExpDirNames)==numel(origLabels));

for ndx = 1:numel(origExpDirNames)

  expdirname = origExpDirNames{ndx};
  data.AddExpDir(expdirname);
  labels = origLabels(ndx);
  origBehName = Q.x.behaviors.names{1};
  origNoBehName = Q.x.behaviors.names{2};
  assert(strcmpi(origNoBehName,'none'));
  newBehName = data.labelnames{1};
  newNoBehName = data.labelnames{2};
  assert(strcmpi(newNoBehName,'none'));
  labels = Labels.renameBehavior(labels,origBehName,newBehName,origNoBehName,newNoBehName);

  obj.labels(ndx) = labels;

end

data.saveJabFile(out_jab_file);
