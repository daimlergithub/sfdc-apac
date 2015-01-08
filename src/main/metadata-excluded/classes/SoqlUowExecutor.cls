public class SoqlUowExecutor
    extends BaseUowExecutor
{
    public override List<OperationResult> execute(List<Operation> aOperationList)
    {
        List<OperationResult> result = new List<OperationResult>();

        if (aOperationList != null) {
            for (Operation query : aOperationList) {
                result.add(executeQuery(query));
            }
        }

        return result;
    }
}