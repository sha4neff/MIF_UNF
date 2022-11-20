//В процедуре необходимо реализовать заполнение таблицы "ОстаткиМаркируемойПродукции". На основании данных таблицы
//будет происходить контроль остатков, если в параметрах сканирования будет заполнено свойство 
//"ОперацияКонтроляАкцизныхМарок" значением  "Продажа" или "Возврат". Первая продажа или возврат контролю не подлежит.
//Если сформирован документ продажи - контроля выполнено не будет, даже если по данным таблицы
//"ОстаткиМаркируемойПродукции" марки нет в наличии. Повторно выполнить продажу той же марки система не даст.
//Если процедура не будет заполнена - никакого контроля выполняться не будет.
// 
// Параметры:
//  ОстаткиМаркируемойПродукции - (См. ШтрихкодированиеМОТП.ИнициализацияТаблицыПроверкиОстатков).
//  ПараметрыСканирования - (См. ШтрихкодированиеИСКлиентСервер.ИнициализироватьПараметрыСканирования).
Процедура ПриОпределенииОстатковМаркируемойПродукции(ОстаткиМаркируемойПродукции, ПараметрыСканирования) Экспорт
	
	ИнтеграцияМОТПУНФ.ПриОпределенииОстатковМаркируемойПродукции(ОстаткиМаркируемойПродукции, ПараметрыСканирования);
	
КонецПроцедуры

// В процедуре необходимо определить необходимость запроса МРЦ для номенклатуры в системе МОТП.
// 
// Параметры:
//  Номенклатура - ОпределяемыйТип.Номенклатура - Номенклатура.
//  ТребуетсяЗапрос - Булево - Истина, если для номенклатуры требуется запрашивать МРЦ в системе МОТП.
Процедура ПриОпределенииНеобходимостиЗапросаМРЦ(Номенклатура, ТребуетсяЗапрос) Экспорт
	
	Если ТребуетсяЗапрос = Неопределено Тогда
		ТребуетсяЗапрос = Ложь;
	КонецЕсли;
	
КонецПроцедуры
