#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ ЗначениеЗаполнено(Объект.ДатаПараметров) Тогда
		Объект.ДатаПараметров=КонецДня(ТекущаяДата());
	КонецЕсли;
	
	Параметры.Свойство("БизнесПроцесс", Объект.БизнесПроцесс);
	
	Если ЗначениеЗаполнено(Объект.БизнесПроцесс) Тогда
		СформироватьДокумент();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура БизнесПроцессПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Объект.БизнесПроцесс) Тогда
		СформироватьДокумент();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СохранитьВФайл(Команда)
	
	Диалог=Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	
	Диалог.Фильтр="MS Excel (*.xls)|*.xls";
	Диалог.Расширение="xls";
	Диалог.ПолноеИмяФайла=ПолноеИмяФайла;

	Если Диалог.Выбрать() Тогда
		ИмяФайла=Диалог.ПолноеИмяФайла;
		ДокТекущиеПараметры.Записать(ИмяФайла, ТипФайлаТабличногоДокумента.XLS);
		Состояние(НСтр("ru='Файл ';")+ИмяФайла+НСтр("ru=' сохранен.';"));
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Распечатать(Команда)
	#Если ТонкийКлиент ИЛИ ВебКлиент Тогда
	Состояние(НСтр("en='Open a dialog to select a printer can only thick client.';ru='Открыть диалог выбора принтеров можно только из толстого клиента.'"));
	ДокТекущиеПараметры.Напечатать(РежимИспользованияДиалогаПечати.НеИспользовать);
	Возврат;
	#Иначе
	ДокТекущиеПараметры.Напечатать(РежимИспользованияДиалогаПечати.Использовать);
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДокумент(Команда)
	Если НЕ ЗначениеЗаполнено(Объект.БизнесПроцесс) Тогда
		ПоказатьПредупреждение(Новый ОписаниеОповещения("ОбновитьДокументЗавершение", ЭтотОбъект), НСтр("en='Please set the business process.';ru='Сначала укажите бизнес-процесс.'"), 60, КП_ОбщееКлиент.ЗаголовокДиалога());
        Возврат;
	КонецЕсли;
	
	ОбновитьДокументФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДокументЗавершение(ДополнительныеПараметры) Экспорт
    
    ОбновитьДокументФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДокументФрагмент()
    
    СформироватьДокумент();

КонецПроцедуры

&НаСервере
Процедура СформироватьДокумент()
	//сформируем табличный документ со списком текущих параметров
	
	ДатаПараметров=ТекущаяДата();
	ДокументТекущиеПараметры=ПолучитьТабличныйДокументТекущиеПараметры(ДатаПараметров);
	ДокументТекущиеПараметры.ФиксацияСверху=4;
	ДокументТекущиеПараметры.ОтображатьСетку=Ложь;
	ДокументТекущиеПараметры.ОтображатьЗаголовки=Ложь;
	
	Если ЗначениеЗаполнено(Объект.БизнесПроцесс) Тогда
		ПредставлениеБизнесПроцесса=СокрЛП(Объект.БизнесПроцесс.Номер);
	Иначе
		ПредставлениеБизнесПроцесса="";
	КонецЕсли;
	
	ПолноеИмяФайла="ТП-"+СокрЛП(ПредставлениеБизнесПроцесса)+Формат(ДатаПараметров, "ДФ=dd-MM-yyyy-hh_mm_ss")+".xls";
		
КонецПроцедуры

&НаСервере
Функция ПолучитьТабличныйДокументТекущиеПараметры(ДатаПараметров)
	
	БизнесПроцесс=Объект.БизнесПроцесс;
	
	//Макет=Обработки.КП_ПараметрыПроцесса.ПолучитьМакет("ТекущиеПараметры");
	Макет=РеквизитФормыВЗначение("Объект").ПолучитьМакет("ТекущиеПараметры");
	ДокТекущиеПараметры=Новый ТабличныйДокумент;

	//выведем шапку		
	ОбластьШапка=Макет.ПолучитьОбласть("Шапка");
	ОбластьПодвал=Макет.ПолучитьОбласть("Подвал");
		
	ОбластьШапка.Параметры.НомерПроцесса=БизнесПроцесс.Номер;
	ОбластьШапка.Параметры.БизнесПроцессСсылка=БизнесПроцесс.Ссылка;
	ОбластьШапка.Параметры.БизнесПроцессНаименование=БизнесПроцесс.Наименование;
	
	ОбластьШапка.Параметры.ДатаВремяПроцесса=Формат(БизнесПроцесс.Дата, "ДФ='dd.MM.yy HH:mm:ss'");
	
	ДокТекущиеПараметры.Вывести(ОбластьШапка);
	
	//обработка точек
	Запрос=Новый Запрос("ВЫБРАТЬ
	                    |	КП_ОбработкаТочекСрезПоследних.Период КАК Период,
	                    |	КП_ОбработкаТочекСрезПоследних.БизнесПроцесс,
	                    |	КП_ОбработкаТочекСрезПоследних.ТочкаКБП,
	                    |	КП_ОбработкаТочекСрезПоследних.НомерПрохода,
	                    |	КП_ОбработкаТочекСрезПоследних.Состояние,
	                    |	КП_ОбработкаТочекСрезПоследних.ПерешлиКТочке,
	                    |	КП_ОбработкаТочекСрезПоследних.Примечание
	                    |ИЗ
	                    |	РегистрСведений.КП_ОбработкаТочек.СрезПоследних(&ДатаКон, БизнесПроцесс = &БизнесПроцесс) КАК КП_ОбработкаТочекСрезПоследних
	                    |
	                    |УПОРЯДОЧИТЬ ПО
	                    |	Период");
	
	ОбластьШапка=Макет.ПолучитьОбласть("ОбработкаТочекШапка");
	ОбластьСтрока=Макет.ПолучитьОбласть("ОбработкаТочекСтрока");
 	Запрос.УстановитьПараметр("ДатаКон", ДатаПараметров);
	Запрос.УстановитьПараметр("БизнесПроцесс", БизнесПроцесс);
	Выборка=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);

	ДокТекущиеПараметры.Вывести(ОбластьШапка);
	Пока Выборка.Следующий() Цикл
		ОбластьСтрока.Параметры.Заполнить(Выборка);
		ДокТекущиеПараметры.Вывести(ОбластьСтрока);
		
	КонецЦикла;
	
	//состояния задач
	Запрос=Новый Запрос("ВЫБРАТЬ
	                    |	КП_СостоянияЗадачСрезПоследних.Период КАК Период,
	                    |	КП_СостоянияЗадачСрезПоследних.Задача КАК ЗадачаСсылка,
	                    |	КП_СостоянияЗадачСрезПоследних.Задача.Наименование КАК ЗадачаНаименование,
	                    |	КП_СостоянияЗадачСрезПоследних.Ответственный,
	                    |	КП_СостоянияЗадачСрезПоследних.СостояниеЗадачи,
	                    |	КП_СостоянияЗадачСрезПоследних.Примечание,
	                    |	КП_СостоянияЗадачСрезПоследних.Задача.ТочкаКБП КАК ТочкаКБП
	                    |ИЗ
	                    |	РегистрСведений.КП_СостоянияЗадач.СрезПоследних(&ДатаКон, Задача.БизнесПроцесс = &БизнесПроцесс) КАК КП_СостоянияЗадачСрезПоследних
	                    |
	                    |УПОРЯДОЧИТЬ ПО
	                    |	Период");
	
	ОбластьШапка=Макет.ПолучитьОбласть("СостоянияЗадачШапка");
	ОбластьСтрока=Макет.ПолучитьОбласть("СостоянияЗадачСтрока");
 	Запрос.УстановитьПараметр("ДатаКон", ДатаПараметров);
	Запрос.УстановитьПараметр("БизнесПроцесс", БизнесПроцесс);
	Выборка=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);

	ДокТекущиеПараметры.Вывести(ОбластьШапка);
	Пока Выборка.Следующий() Цикл
		ОбластьСтрока.Параметры.Заполнить(Выборка);
		ДокТекущиеПараметры.Вывести(ОбластьСтрока);
		
	КонецЦикла;
		
	//результаты исполнителей
	Запрос=Новый Запрос("ВЫБРАТЬ
	                    |	КП_РезультатыИсполнителейЗадачСрезПоследних.Период КАК Период,
	                    |	КП_РезультатыИсполнителейЗадачСрезПоследних.БизнесПроцесс,
	                    |	КП_РезультатыИсполнителейЗадачСрезПоследних.Исполнитель,
	                    |	КП_РезультатыИсполнителейЗадачСрезПоследних.ПараметрРезультата,
	                    |	КП_РезультатыИсполнителейЗадачСрезПоследних.ИднИсполнителя,
	                    |	КП_РезультатыИсполнителейЗадачСрезПоследних.ТочкаКБП,
	                    |	КП_РезультатыИсполнителейЗадачСрезПоследних.Задача КАК ЗадачаСсылка,
	                    |	КП_РезультатыИсполнителейЗадачСрезПоследних.Задача.Наименование КАК ЗадачаНаименование,
	                    |	КП_РезультатыИсполнителейЗадачСрезПоследних.ЗначениеПараметра
	                    |ИЗ
	                    |	РегистрСведений.КП_РезультатыИсполнителейЗадач.СрезПоследних(&ДатаКон, БизнесПроцесс = &БизнесПроцесс) КАК КП_РезультатыИсполнителейЗадачСрезПоследних
	                    |
	                    |УПОРЯДОЧИТЬ ПО
	                    |	Период");
	
	ОбластьШапка=Макет.ПолучитьОбласть("РезультатыИсполнителейШапка");
	ОбластьСтрока=Макет.ПолучитьОбласть("РезультатыИсполнителейСтрока");
 	Запрос.УстановитьПараметр("ДатаКон", ДатаПараметров);
	Запрос.УстановитьПараметр("БизнесПроцесс", БизнесПроцесс);
	Выборка=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);

	ДокТекущиеПараметры.Вывести(ОбластьШапка);
	Пока Выборка.Следующий() Цикл
		ОбластьСтрока.Параметры.Заполнить(Выборка);
		ДокТекущиеПараметры.Вывести(ОбластьСтрока);
		
	КонецЦикла;
	
	//сеть маршрутных точек
	Запрос=Новый Запрос("ВЫБРАТЬ
	                    |	КП_БизнесПроцессСетьМаршрутныхТочек.Ссылка,
	                    |	КП_БизнесПроцессСетьМаршрутныхТочек.НомерСтроки,
	                    |	КП_БизнесПроцессСетьМаршрутныхТочек.ТочкаВыход,
	                    |	КП_БизнесПроцессСетьМаршрутныхТочек.ТочкаВход,
	                    |	КП_БизнесПроцессСетьМаршрутныхТочек.УсловныйПереход,
	                    |	КП_БизнесПроцессСетьМаршрутныхТочек.ЗначениеРеквизита,
	                    |	КП_БизнесПроцессСетьМаршрутныхТочек.ИмяЛинииНаСхеме,
	                    |	КП_БизнесПроцессСетьМаршрутныхТочек.УсловиеПерехода,
	                    |	КП_БизнесПроцессСетьМаршрутныхТочек.УсловиеПереходаНаименование
	                    |ИЗ
	                    |	БизнесПроцесс.КП_БизнесПроцесс.СетьМаршрутныхТочек КАК КП_БизнесПроцессСетьМаршрутныхТочек
	                    |ГДЕ
	                    |	КП_БизнесПроцессСетьМаршрутныхТочек.Ссылка = &БизнесПроцесс");
	
	ОбластьШапка=Макет.ПолучитьОбласть("СетьМаршрутныхТочекШапка");
	ОбластьСтрока=Макет.ПолучитьОбласть("СетьМаршрутныхТочекСтрока");
	Запрос.УстановитьПараметр("БизнесПроцесс", БизнесПроцесс);
	Выборка=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);

	ДокТекущиеПараметры.Вывести(ОбластьШапка);
	Пока Выборка.Следующий() Цикл
		ОбластьСтрока.Параметры.Заполнить(Выборка);
		ДокТекущиеПараметры.Вывести(ОбластьСтрока);
		СтрокаУсловия=СокрЛП(Выборка.УсловиеПереходаНаименование)+?(Выборка.УсловиеПерехода=0, "", "("+СокрЛП(Выборка.УсловиеПерехода)+")");
		ОбластьСтрока.Параметры.УсловныйПереходТекст=СтрокаУсловия;
		
	КонецЦикла;
	
	ОбластьПодвал.Параметры.ДатаВремяФормирования=ДатаПараметров;
	ДокТекущиеПараметры.Вывести(ОбластьПодвал);
	
	Возврат ДокТекущиеПараметры;
	
КонецФункции

#КонецОбласти
