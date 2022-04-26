sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'vv/kitchenstorefiori/test/integration/pages/MainListReport' ,
        'vv/kitchenstorefiori/test/integration/pages/MainObjectPage',
        'vv/kitchenstorefiori/test/integration/OpaJourney'
    ],
    function(JourneyRunner, MainListReport, MainObjectPage, Journey) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('vv/kitchenstorefiori') + '/index.html'
        });

        
        JourneyRunner.run(
            {
                pages: { onTheMainPage: MainListReport, onTheDetailPage: MainObjectPage }
            },
            Journey.run
        );
        
    }
);